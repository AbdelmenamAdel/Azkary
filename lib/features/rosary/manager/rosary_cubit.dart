import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'rosary_state.dart';

class RosaryCubit extends Cubit<RosaryState> {
  final FlutterSecureStorage _storage;
  Timer? _saveTimer;

  RosaryCubit(this._storage) : super(RosaryState.initial()) {
    loadData();
  }

  static const String _detailedHistoryKey = 'rosary_detailed_history';
  static const String _streakKey = 'rosary_streak';
  static const String _lastDateKey = 'rosary_last_date';
  static const String _customZekrsKey = 'rosary_custom_zekrs';

  String _getToday() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<void> loadData() async {
    try {
      final detailedHistoryStr = await _storage.read(key: _detailedHistoryKey);
      final streakStr = await _storage.read(key: _streakKey);
      final lastDate = await _storage.read(key: _lastDateKey) ?? '';
      final customZekrsStr = await _storage.read(key: _customZekrsKey);

      Map<String, Map<String, int>> detailedHistory = {};
      if (detailedHistoryStr != null) {
        final decoded = jsonDecode(detailedHistoryStr) as Map<String, dynamic>;
        detailedHistory = decoded.map((date, zekrs) {
          final zekrMap = (zekrs as Map<String, dynamic>).map(
            (z, c) => MapEntry(z, c as int),
          );
          return MapEntry(date, zekrMap);
        });
      }

      int streak = int.tryParse(streakStr ?? '0') ?? 0;
      List<String> customZekrs = state.customZekrs;
      if (customZekrsStr != null) {
        customZekrs = List<String>.from(jsonDecode(customZekrsStr));
      }

      final today = _getToday();

      // Calculate totalToday from detailedHistory
      int totalToday = 0;
      if (detailedHistory.containsKey(today)) {
        totalToday = detailedHistory[today]!.values.fold(
          0,
          (sum, count) => sum + count,
        );
      }

      // Reset streak if missed a day
      if (lastDate.isNotEmpty && lastDate != today) {
        final lastDateTime = DateTime.parse(lastDate);
        final todayDateTime = DateTime.parse(today);
        final difference = todayDateTime.difference(lastDateTime).inDays;

        if (difference > 1) {
          streak = 0;
        }
      }

      emit(
        state.copyWith(
          detailedHistory: detailedHistory,
          streak: streak,
          lastDate: lastDate,
          customZekrs: customZekrs,
          totalToday: totalToday,
        ),
      );
    } catch (e) {
      print('Error loading rosary data: $e');
    }
  }

  Future<void> increment() async {
    final today = _getToday();
    final currentZekr = state.currentZekr;

    final newDetailedHistory = Map<String, Map<String, int>>.from(
      state.detailedHistory.map(
        (k, v) => MapEntry(k, Map<String, int>.from(v)),
      ),
    );

    if (!newDetailedHistory.containsKey(today)) {
      newDetailedHistory[today] = {};
    }

    final int currentCount = newDetailedHistory[today]![currentZekr] ?? 0;
    newDetailedHistory[today]![currentZekr] = currentCount + 1;

    final int newTotalToday = newDetailedHistory[today]!.values.fold(
      0,
      (sum, item) => sum + item,
    );

    int newStreak = state.streak;
    String newLastDate = state.lastDate;

    if (state.lastDate != today) {
      if (state.lastDate.isNotEmpty) {
        final lastDateTime = DateTime.parse(state.lastDate);
        final todayDateTime = DateTime.parse(today);
        final difference = todayDateTime.difference(lastDateTime).inDays;

        if (difference == 1) {
          newStreak++;
        } else if (difference > 1) {
          newStreak = 1;
        }
      } else {
        newStreak = 1;
      }
      newLastDate = today;
    }

    final int updatedZekrCount = newDetailedHistory[today]![currentZekr] ?? 0;

    emit(
      state.copyWith(
        counter: updatedZekrCount,
        totalToday: newTotalToday,
        detailedHistory: newDetailedHistory,
        streak: newStreak,
        lastDate: newLastDate,
      ),
    );

    _debouncedSave();
  }

  void _debouncedSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), () {
      _saveData();
    });
  }

  Future<void> resetCounter() async {
    emit(state.copyWith(counter: 0));
  }

  Future<void> changeZekr(String zekr) async {
    final today = _getToday();
    final todayCount = state.detailedHistory[today]?[zekr] ?? 0;
    emit(state.copyWith(currentZekr: zekr, counter: todayCount));
  }

  Future<void> addCustomZekr(String zekr) async {
    if (zekr.trim().isEmpty || state.customZekrs.contains(zekr)) return;

    final newList = List<String>.from(state.customZekrs)..add(zekr);
    emit(state.copyWith(customZekrs: newList, currentZekr: zekr, counter: 0));
    await _storage.write(key: _customZekrsKey, value: jsonEncode(newList));
  }

  Future<void> removeZekr(String zekr) async {
    if (state.customZekrs.length <= 1) return;

    final newList = List<String>.from(state.customZekrs)..remove(zekr);

    String newCurrentZekr = state.currentZekr;
    int newCounter = state.counter;

    if (state.currentZekr == zekr) {
      newCurrentZekr = newList[0];
      final today = _getToday();
      newCounter = state.detailedHistory[today]?[newCurrentZekr] ?? 0;
    }

    emit(
      state.copyWith(
        customZekrs: newList,
        currentZekr: newCurrentZekr,
        counter: newCounter,
      ),
    );

    await _storage.write(key: _customZekrsKey, value: jsonEncode(newList));
  }

  Future<void> _saveData() async {
    await _storage.write(
      key: _detailedHistoryKey,
      value: jsonEncode(state.detailedHistory),
    );
    await _storage.write(key: _streakKey, value: state.streak.toString());
    await _storage.write(key: _lastDateKey, value: state.lastDate);
  }

  @override
  Future<void> close() {
    _saveTimer?.cancel();
    _saveData(); // Save one last time before closing
    return super.close();
  }
}
