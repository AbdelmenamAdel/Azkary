import 'package:azkar/core/localization/app_localizations.dart';
import 'package:azkar/core/theme/app_colors_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ElectronicRosaryView extends StatefulWidget {
  const ElectronicRosaryView({super.key});

  @override
  State<ElectronicRosaryView> createState() => _ElectronicRosaryViewState();
}

class _ElectronicRosaryViewState extends State<ElectronicRosaryView>
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  int _totalCounter = 0;
  int _maxCount = 33;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

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
    super.dispose();
  }

  void _incrementCounter() {
    HapticFeedback.lightImpact();
    _animationController.forward().then((_) => _animationController.reverse());

    setState(() {
      _counter++;
      _totalCounter++;
      if (_counter >= _maxCount) {
        _counter = 0;
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _resetCounter() {
    HapticFeedback.mediumImpact();
    setState(() {
      _counter = 0;
      _totalCounter = 0;
    });
  }

  void _changeMaxCount(int newMax) {
    setState(() {
      _maxCount = newMax;
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = _counter / _maxCount;

    return Scaffold(
      backgroundColor: colors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors.primary!,
              colors.background!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: colors.secondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        context.translate('electronic_rosary'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: colors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              const Spacer(),

              // Main Counter Display
              GestureDetector(
                onTap: _incrementCounter,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Container(
                          width: 280,
                          height: 280,
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
                                color: colors.primary!.withValues(alpha: 0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: colors.secondary!.withValues(alpha: 0.3),
                                blurRadius: 50,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Progress Ring
                              Positioned.fill(
                                child: CircularProgressIndicator(
                                  value: progress,
                                  strokeWidth: 8,
                                  backgroundColor:
                                      colors.background!.withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    colors.secondary!,
                                  ),
                                ),
                              ),
                              // Counter Text
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_counter',
                                      style: TextStyle(
                                        fontSize: 80,
                                        fontWeight: FontWeight.bold,
                                        color: colors.background,
                                        fontFamily: 'Cairo',
                                        shadows: const [
                                          Shadow(
                                            color: Colors.black26,
                                            offset: Offset(2, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '/ $_maxCount',
                                      style: TextStyle(
                                        fontSize: 24,
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

              const SizedBox(height: 40),

              // Total Counter
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.primary!.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colors.secondary!.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      context.translate('total_count'),
                      style: TextStyle(
                        fontSize: 16,
                        color: colors.text!.withValues(alpha: 0.7),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_totalCounter',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: colors.subtext,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Max Count Selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMaxCountButton(33, colors),
                    const SizedBox(width: 16),
                    _buildMaxCountButton(99, colors),
                    const SizedBox(width: 16),
                    _buildMaxCountButton(100, colors),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Reset Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: _resetCounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.secondary,
                    foregroundColor: colors.background,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.refresh, color: colors.background),
                      const SizedBox(width: 8),
                      Text(
                        context.translate('reset'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: colors.background,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMaxCountButton(int count, colors) {
    final isSelected = _maxCount == count;
    return GestureDetector(
      onTap: () => _changeMaxCount(count),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.secondary!.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Text(
          '$count',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isSelected ? colors.surface : colors.text,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}
