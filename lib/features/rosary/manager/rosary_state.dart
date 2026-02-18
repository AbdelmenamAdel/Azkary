import 'package:intl/intl.dart';

class RosaryState {
  final int counter;
  final int totalToday;
  final int streak;
  final String lastDate;
  final Map<String, Map<String, int>>
  detailedHistory; // Date -> {Zekr -> Count}
  final List<String> customZekrs;
  final String currentZekr;

  const RosaryState({
    required this.counter,
    required this.totalToday,
    required this.streak,
    required this.lastDate,
    required this.detailedHistory,
    required this.customZekrs,
    required this.currentZekr,
  });

  factory RosaryState.initial() {
    return const RosaryState(
      counter: 0,
      totalToday: 0,
      streak: 0,
      lastDate: '',
      detailedHistory: {},
      customZekrs: [
        'سبحان الله',
        'الحمد لله',
        'لا إله إلا الله',
        'الله أكبر',
        'أستغفر الله',
        'لا حول ولا قوة إلا بالله',
        'اللهم صل على محمد',
      ],
      currentZekr: 'سبحان الله',
    );
  }

  int get currentZekrToday {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return detailedHistory[today]?[currentZekr] ?? 0;
  }

  int get currentZekrAllTimeMax {
    int max = 0;
    for (var dateMap in detailedHistory.values) {
      final count = dateMap[currentZekr] ?? 0;
      if (count > max) max = count;
    }
    return max;
  }

  int get overallAllTimeMax {
    int max = 0;
    for (var dateMap in detailedHistory.values) {
      final dailyTotal = dateMap.values.fold(0, (sum, count) => sum + count);
      if (dailyTotal > max) max = dailyTotal;
    }
    return max;
  }

  RosaryState copyWith({
    int? counter,
    int? totalToday,
    int? streak,
    String? lastDate,
    Map<String, Map<String, int>>? detailedHistory,
    List<String>? customZekrs,
    String? currentZekr,
  }) {
    return RosaryState(
      counter: counter ?? this.counter,
      totalToday: totalToday ?? this.totalToday,
      streak: streak ?? this.streak,
      lastDate: lastDate ?? this.lastDate,
      detailedHistory: detailedHistory ?? this.detailedHistory,
      customZekrs: customZekrs ?? this.customZekrs,
      currentZekr: currentZekr ?? this.currentZekr,
    );
  }
}
