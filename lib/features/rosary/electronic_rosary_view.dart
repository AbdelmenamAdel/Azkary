import 'package:audioplayers/audioplayers.dart';
import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:azkar/features/rosary/manager/rosary_cubit.dart';
import 'package:azkar/features/rosary/manager/rosary_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final ScrollController _zekrScrollController = ScrollController();
  final Map<int, GlobalKey> _zekrKeys = {};

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
    _zekrScrollController.dispose();
    super.dispose();
  }

  void _incrementCounter(BuildContext context, RosaryState state) {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) => _animationController.reverse());

    context.read<RosaryCubit>().increment();

    // Auto-scroll to current zikr when tapping the counter
    final currentIndex = state.customZekrs.indexOf(state.currentZekr);
    if (currentIndex != -1) {
      _scrollToZekr(currentIndex);
    }

    final nextCount = state.counter + 1;
    if (nextCount > 0 && nextCount % _maxCount == 0) {
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

  void _scrollToZekr(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _zekrKeys[index];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.5,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          context.translate('electronic_rosary'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: colors.secondary,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.bar_chart_rounded,
                            color: colors.secondary,
                          ),
                          onPressed: () => _showDetailedStatsBottomSheet(
                            context,
                            context.read<RosaryCubit>().state,
                            colors,
                          ),
                        ),
                        BlocSelector<RosaryCubit, RosaryState, int>(
                          selector: (state) => state.streak,
                          builder: (context, streak) {
                            return _buildStreakWidget(streak, colors);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Zekr Selection (Needs its own BlocBuilder for current/custom list)
              _buildZekrSelector(
                context,
                context.read<RosaryCubit>().state,
                colors,
              ),

              const Spacer(),

              // Main Counter Display
              BlocBuilder<RosaryCubit, RosaryState>(
                buildWhen: (p, c) => p.counter != c.counter,
                builder: (context, state) {
                  double progress = (state.counter % _maxCount) / _maxCount;
                  if (progress == 0 &&
                      state.counter > 0 &&
                      state.counter % _maxCount == 0) {
                    progress = 1.0;
                  }
                  return GestureDetector(
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
                                        SizedBox(
                                          width: 180,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              '${state.counter}',
                                              style: TextStyle(
                                                fontSize: 75,
                                                fontWeight: FontWeight.bold,
                                                color: colors.background,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
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
                  );
                },
              ),

              const Spacer(),

              // Max Count Selector (Static UI)
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
                      Icon(Icons.refresh, color: colors.background, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        context.translate('reset'),
                        style: const TextStyle(
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
  }

  Widget _buildStreakWidget(int streak, dynamic colors) {
    return GestureDetector(
      onTap: () => _showMonthlyCalendar(
        context,
        context.read<RosaryCubit>().state,
        colors,
      ),
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
            const Icon(FontAwesomeIcons.fire, color: Colors.orange, size: 16),
            const SizedBox(width: 6),
            Text(
              '$streak',
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
    return BlocBuilder<RosaryCubit, RosaryState>(
      buildWhen: (p, c) =>
          p.currentZekr != c.currentZekr || p.customZekrs != c.customZekrs,
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 50,
              child: ListView.builder(
                controller: _zekrScrollController,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.customZekrs.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.customZekrs.length) {
                    return _buildAddZekrButton(context, colors);
                  }
                  final zekr = state.customZekrs[index];
                  final isSelected = state.currentZekr == zekr;
                  final itemKey = _zekrKeys.putIfAbsent(
                    index,
                    () => GlobalKey(),
                  );

                  return GestureDetector(
                    key: itemKey,
                    onTap: () {
                      context.read<RosaryCubit>().changeZekr(zekr);
                      _scrollToZekr(index);
                    },
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
      },
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
                context.read<RosaryCubit>().addCustomZekr(
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

  void _showDetailedStatsBottomSheet(
    BuildContext context,
    RosaryState state,
    dynamic colors,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.text!.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${context.translate('insights_for')} ${state.currentZekr}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.secondary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildCurrentZekrStats(context, state, colors),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDailyStats(context, state, colors)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.secondary!.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: colors.secondary!.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.secondary!.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: colors.secondary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.translate('overall_best'),
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.secondary,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        Text(
                          '${state.overallAllTimeMax}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colors.secondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // const Spacer(),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showMonthlyCalendar(context, state, colors);
                },
                icon: Icon(Icons.calendar_month, color: colors.secondary),
                label: Text(
                  context.translate('monthly_report'),
                  style: TextStyle(
                    color: colors.secondary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentZekrStats(
    BuildContext context,
    RosaryState state,
    dynamic colors,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.secondary!.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: colors.secondary!.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colors.secondary!.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.stars_rounded, size: 20, color: colors.secondary),
          ),
          const SizedBox(height: 12),
          Text(
            context.translate('best'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: colors.secondary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${state.currentZekrAllTimeMax}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colors.secondary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${context.translate('daily_record')}: ${state.currentZekrToday}',
            style: TextStyle(
              fontSize: 9,
              color: colors.secondary,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
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
      onTap: () {
        Navigator.pop(context);
        _showHistoryBottomSheet(context, state, colors);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.text!.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: colors.text!.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.text!.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today_rounded,
                size: 20,
                color: colors.text,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              context.translate('total_today'),
              style: TextStyle(
                fontSize: 11,
                color: colors.text!.withValues(alpha: 0.6),
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
            ),
            FittedBox(
              child: Text(
                '${state.totalToday}',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colors.text,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.translate('view_history'),
                  style: TextStyle(
                    fontSize: 9,
                    color: colors.text!.withValues(alpha: 0.6),
                    decoration: TextDecoration.underline,
                    fontFamily: 'Cairo',
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 10,
                  color: colors.text!.withValues(alpha: 0.6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaxCountButton(BuildContext context, int count, dynamic colors) {
    final isSelected = _maxCount == count;
    return GestureDetector(
      onTap: () => _changeMaxCount(context, count),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? colors.secondary!
                : colors.secondary!.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          '$count',
          style: TextStyle(
            color: isSelected ? colors.background : colors.secondary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                  context.translate('no_history_yet'),
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
                        color: colors.surface!.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colors.secondary!.withValues(alpha: 0.2),
                        ),
                      ),
                      child: ExpansionTile(
                        // trailing: Icon(
                        //   Icons.arrow_forward_ios,
                        //   size: 16,
                        //   color: colors.text!.withValues(alpha: 0.8),
                        // ),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide.none,
                        ),
                        title: Text(
                          date ==
                                  DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(DateTime.now())
                              ? context.translate('today')
                              : date,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colors.text,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        subtitle: Text(
                          '${context.translate('total_count')}: $totalForDate',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.text!.withValues(alpha: 0.6),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        children: sortedZekrs.map((zekr) {
                          return ListTile(
                            title: Text(
                              zekr,
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.text,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            trailing: Text(
                              '${zekrCounts[zekr]}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: colors.secondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          );
                        }).toList(),
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
}

class _MonthlyCalendarSheet extends StatefulWidget {
  final RosaryState state;
  final dynamic colors;

  const _MonthlyCalendarSheet({required this.state, required this.colors});

  @override
  State<_MonthlyCalendarSheet> createState() => _MonthlyCalendarSheetState();
}

class _MonthlyCalendarSheetState extends State<_MonthlyCalendarSheet> {
  DateTime _viewDate = DateTime.now();

  void _nextMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + 1);
    });
  }

  void _prevMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.colors;
    final firstDay = DateTime(_viewDate.year, _viewDate.month, 1);
    final lastDay = DateTime(_viewDate.year, _viewDate.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startWeekday = firstDay.weekday % 7;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: colors.secondary),
                onPressed: _prevMonth,
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    DateFormat('MMMM yyyy').format(_viewDate),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.secondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: colors.secondary),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildWeekdayHeader(colors),
          const SizedBox(height: 8),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: startWeekday + daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
              ),
              itemBuilder: (context, index) {
                if (index < startWeekday) return const SizedBox();
                final dayNum = index - startWeekday + 1;
                final date = DateTime(_viewDate.year, _viewDate.month, dayNum);
                final dateKey = DateFormat('yyyy-MM-dd').format(date);
                final zekrCounts = widget.state.detailedHistory[dateKey] ?? {};
                final totalCount = zekrCounts.values.fold(
                  0,
                  (sum, c) => sum + c,
                );

                return _buildDayCell(dayNum, totalCount, date);
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('0', colors.surface!.withValues(alpha: 0.2)),
              _buildLegendItem(
                '1-100',
                colors.secondary!.withValues(alpha: 0.4),
              ),
              _buildLegendItem(
                '100-500',
                colors.secondary!.withValues(alpha: 0.7),
              ),
              _buildLegendItem('1000+', colors.secondary!),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader(dynamic colors) {
    final weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((d) {
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            d,
            style: TextStyle(
              fontSize: 14,
              color: colors.text!.withValues(alpha: 0.5),
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
        );
      }).toList(),
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
        cellColor = colors.secondary!.withValues(alpha: 0.2);
      } else if (count < 500) {
        cellColor = colors.secondary!.withValues(alpha: 0.4);
        textColor = colors.background;
      } else if (count < 1000) {
        cellColor = colors.secondary!.withValues(alpha: 0.7);
        textColor = colors.background;
      } else {
        cellColor = colors.secondary!;
        textColor = colors.background;
      }
    }

    String displayCount = count > 9999
        ? '${(count / 1000).toStringAsFixed(1)}k'
        : '$count';

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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isToday ? FontWeight.w900 : FontWeight.normal,
                  color: textColor,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            if (count > 0)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  displayCount,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: textColor.withValues(alpha: 0.8),
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
