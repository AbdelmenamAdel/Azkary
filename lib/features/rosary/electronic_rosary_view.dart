import 'package:audioplayers/audioplayers.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/features/rosary/manager/rosary_cubit.dart';
import 'package:azkar/features/rosary/manager/rosary_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class ElectronicRosaryView extends StatefulWidget {
  const ElectronicRosaryView({super.key});

  @override
  State<ElectronicRosaryView> createState() => _ElectronicRosaryViewState();
}

class _ElectronicRosaryViewState extends State<ElectronicRosaryView>
    with SingleTickerProviderStateMixin {
  int _maxCount = 33;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _customZekrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _audioPlayer.dispose();
    _customZekrController.dispose();
    super.dispose();
  }

  void _incrementCounter(BuildContext context, RosaryState state) {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) => _animationController.reverse());

    context.read<RosaryCubit>().increment();

    if (state.counter + 1 >= _maxCount) {
      context.read<RosaryCubit>().resetCounter();
      HapticFeedback.heavyImpact();
      _audioPlayer.play(AssetSource('sounds/full_sound.mp3'));
    } else {
      _audioPlayer.play(AssetSource('sounds/click_sepha.mp3'));
    }
  }

  void _resetCounter(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<RosaryCubit>().resetCounter();
  }

  void _changeMaxCount(BuildContext context, int newMax) {
    setState(() {
      _maxCount = newMax;
    });
    context.read<RosaryCubit>().resetCounter();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocBuilder<RosaryCubit, RosaryState>(
      builder: (context, state) {
        final progress = state.counter / _maxCount;

        return Scaffold(
          backgroundColor: colors.background,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colors.primary!, colors.background!],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: colors.secondary),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          context.translate('electronic_rosary'),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: colors.secondary,
                          ),
                        ),
                        _buildStreakWidget(state, colors),
                      ],
                    ),
                  ),

                  // Zekr Selection
                  _buildZekrSelector(context, state, colors),

                  const Spacer(),

                  // Main Counter Display
                  GestureDetector(
                    onTap: () => _incrementCounter(context, state),
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Container(
                              width: 260,
                              height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colors.primary!,
                                    colors.primary!.withValues(alpha: 0.8),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.primary!.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                  BoxShadow(
                                    color: colors.secondary!.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 50,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: CircularProgressIndicator(
                                      value: progress,
                                      strokeWidth: 8,
                                      backgroundColor: colors.background!
                                          .withValues(alpha: 0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        colors.secondary!,
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${state.counter}',
                                          style: TextStyle(
                                            fontSize: 70,
                                            fontWeight: FontWeight.bold,
                                            color: colors.background,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        Text(
                                          '/ $_maxCount',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: colors.background!
                                                .withValues(alpha: 0.8),
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // History & Daily Stats
                  _buildDailyStats(context, state, colors),

                  const Spacer(),

                  // Max Count Selector
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildMaxCountButton(context, 33, colors),
                        const SizedBox(width: 12),
                        _buildMaxCountButton(context, 99, colors),
                        const SizedBox(width: 12),
                        _buildMaxCountButton(context, 100, colors),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Reset Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () => _resetCounter(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.secondary,
                        foregroundColor: colors.background,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.refresh,
                            color: colors.background,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            context.translate('reset'),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreakWidget(RosaryState state, dynamic colors) {
    return GestureDetector(
      onTap: () => _showMonthlyCalendar(context, state, colors),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: colors.secondary!.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.secondary!.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(FontAwesomeIcons.fire, color: Colors.orange, size: 16),
            const SizedBox(width: 6),
            Text(
              '${state.streak}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.secondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildZekrSelector(
    BuildContext context,
    RosaryState state,
    dynamic colors,
  ) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.customZekrs.length + 1,
            itemBuilder: (context, index) {
              if (index == state.customZekrs.length) {
                return _buildAddZekrButton(context, colors);
              }
              final zekr = state.customZekrs[index];
              final isSelected = state.currentZekr == zekr;
              return GestureDetector(
                onTap: () => context.read<RosaryCubit>().changeZekr(zekr),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.secondary
                        : colors.surface!.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? colors.secondary!
                          : colors.secondary!.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      zekr,
                      style: TextStyle(
                        color: isSelected ? colors.background : colors.text,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          state.currentZekr,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colors.secondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Widget _buildAddZekrButton(BuildContext context, dynamic colors) {
    return GestureDetector(
      onTap: () => _showAddZekrDialog(context, colors),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.surface!.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: colors.secondary!.withValues(alpha: 0.5),
            style: BorderStyle.values[1],
          ),
        ),
        child: Icon(Icons.add, color: colors.secondary),
      ),
    );
  }

  void _showAddZekrDialog(BuildContext context, dynamic colors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.background,
        title: Text(
          context.translate('add_zekr'),
          style: TextStyle(color: colors.secondary, fontFamily: 'Cairo'),
        ),
        content: TextField(
          controller: _customZekrController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: '...',
            hintStyle: TextStyle(color: colors.text!.withValues(alpha: 0.5)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.secondary!),
            ),
          ),
          style: TextStyle(color: colors.text, fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              context.translate('cancel'),
              style: TextStyle(color: colors.text),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_customZekrController.text.isNotEmpty) {
                this.context.read<RosaryCubit>().addCustomZekr(
                  _customZekrController.text,
                );
                _customZekrController.clear();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.secondary),
            child: Text(
              context.translate('add'),
              style: TextStyle(color: colors.background),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyStats(
    BuildContext context,
    RosaryState state,
    dynamic colors,
  ) {
    return GestureDetector(
      onTap: () => _showHistoryBottomSheet(context, state, colors),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colors.primary!.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colors.secondary!.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, size: 16, color: colors.text),
                const SizedBox(width: 8),
                Text(
                  context.translate('total_today'),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.text!.withValues(alpha: 0.7),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${state.totalToday}',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: colors.text,
                fontFamily: 'Cairo',
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.translate('view_history'),
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.text,
                    decoration: TextDecoration.underline,
                    fontFamily: 'Cairo',
                  ),
                ),
                Icon(Icons.chevron_right, size: 14, color: colors.text),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthlyCalendar(
    BuildContext context,
    RosaryState state,
    dynamic colors,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _MonthlyCalendarSheet(state: state, colors: colors),
    );
  }

  void _showHistoryBottomSheet(
    BuildContext context,
    RosaryState state,
    dynamic colors,
  ) {
    final sortedDates = state.detailedHistory.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colors.text!.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              context.translate('history'),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.secondary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 16),
            if (sortedDates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'No history yet',
                  style: TextStyle(color: colors.text, fontFamily: 'Cairo'),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, dateIndex) {
                    final date = sortedDates[dateIndex];
                    final zekrCounts = state.detailedHistory[date]!;
                    final sortedZekrs = zekrCounts.keys.toList()
                      ..sort(
                        (a, b) => zekrCounts[b]!.compareTo(zekrCounts[a]!),
                      );
                    final totalForDate = zekrCounts.values.fold(
                      0,
                      (sum, c) => sum + c,
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: colors.primary!.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colors.secondary!.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colors.secondary!.withValues(alpha: 0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                      color: colors.secondary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      date,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.secondary,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '$totalForDate',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colors.secondary,
                                    fontSize: 18,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...sortedZekrs.map(
                            (zekr) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      zekr,
                                      style: TextStyle(
                                        color: colors.text,
                                        fontSize: 16,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.secondary!.withValues(
                                        alpha: 0.05,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${zekrCounts[zekr]}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: colors.secondary,
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaxCountButton(BuildContext context, int count, colors) {
    final isSelected = _maxCount == count;
    return GestureDetector(
      onTap: () => _changeMaxCount(context, count),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    colors.secondary!,
                    colors.secondary!.withValues(alpha: 0.8),
                  ],
                )
              : null,
          color: isSelected ? null : colors.surface!.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? colors.secondary!
                : colors.text!.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? colors.surface : colors.text,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}

class _MonthlyCalendarSheet extends StatefulWidget {
  final RosaryState state;
  final dynamic colors;

  const _MonthlyCalendarSheet({required this.state, required this.colors});

  @override
  State<_MonthlyCalendarSheet> createState() => _MonthlyCalendarSheetState();
}

class _MonthlyCalendarSheetState extends State<_MonthlyCalendarSheet> {
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _focusedMonth = DateTime.now();
  }

  void _prevMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
  });

  void _nextMonth() => setState(() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
  });

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final state = widget.state;

    final monthName = DateFormat.MMMM(
      Localizations.localeOf(context).languageCode,
    ).format(_focusedMonth);
    final year = _focusedMonth.year;

    final firstDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _focusedMonth.year,
      _focusedMonth.month + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colors.text!.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          // Month Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: colors.secondary,
                ),
                onPressed: _prevMonth,
              ),
              Text(
                '$monthName $year',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.secondary,
                  fontFamily: 'Cairo',
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: colors.secondary,
                ),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Weekdays
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                .map(
                  (d) => SizedBox(
                    width: 40,
                    child: Text(
                      d,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: colors.text!.withValues(alpha: 0.5),
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          // Grid
          Expanded(
            child: GridView.builder(
              itemCount: 42, // 6 weeks
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final dayNumber = index - startWeekday + 1;
                if (dayNumber < 1 || dayNumber > daysInMonth)
                  return const SizedBox.shrink();

                final date = DateTime(
                  _focusedMonth.year,
                  _focusedMonth.month,
                  dayNumber,
                );
                final dateKey = DateFormat('yyyy-MM-dd').format(date);

                int totalDay = 0;
                if (state.detailedHistory.containsKey(dateKey)) {
                  totalDay = state.detailedHistory[dateKey]!.values.fold(
                    0,
                    (sum, c) => sum + c,
                  );
                }

                return _buildDayCell(dayNumber, totalDay, date);
              },
            ),
          ),
          // Legend
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('0', colors.surface!.withValues(alpha: 0.2)),
                const SizedBox(width: 8),
                _buildLegendItem(
                  '1-99',
                  colors.secondary!.withValues(alpha: 0.3),
                ),
                const SizedBox(width: 8),
                _buildLegendItem(
                  '100-299',
                  colors.secondary!.withValues(alpha: 0.6),
                ),
                const SizedBox(width: 8),
                _buildLegendItem('300+', colors.secondary!),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontFamily: 'Cairo')),
      ],
    );
  }

  Widget _buildDayCell(int day, int count, DateTime date) {
    final colors = widget.colors;
    final isToday =
        DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    Color cellColor = colors.surface!.withValues(alpha: 0.1);
    Color textColor = colors.text;

    if (count > 0) {
      if (count < 100) {
        cellColor = colors.secondary!.withValues(alpha: 0.3);
      } else if (count < 300) {
        cellColor = colors.secondary!.withValues(alpha: 0.6);
        textColor = colors.background;
      } else {
        cellColor = colors.secondary!;
        textColor = colors.background;
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        shape: BoxShape.circle,
        border: isToday ? Border.all(color: colors.primary!, width: 2) : null,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: colors.primary!.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: textColor,
                fontFamily: 'Cairo',
              ),
            ),
            if (count > 0)
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 8,
                  color: textColor.withValues(alpha: 0.7),
                  fontFamily: 'Cairo',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
