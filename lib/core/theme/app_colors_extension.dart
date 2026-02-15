import 'package:flutter/material.dart';

class MyColors extends ThemeExtension<MyColors> {
  final Color? primary;
  final Color? secondary;
  final Color? background;
  final Color? surface;
  final Color? text;
  final Color? subtext;

  const MyColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.text,
    required this.subtext,
  });

  @override
  MyColors copyWith({
    Color? primary,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? text,
    Color? subtext,
  }) {
    return MyColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      text: text ?? this.text,
      subtext: subtext ?? this.subtext,
    );
  }

  @override
  MyColors lerp(ThemeExtension<MyColors>? other, double t) {
    if (other is! MyColors) return this;
    return MyColors(
      primary: Color.lerp(primary, other.primary, t),
      secondary: Color.lerp(secondary, other.secondary, t),
      background: Color.lerp(background, other.background, t),
      surface: Color.lerp(surface, other.surface, t),
      text: Color.lerp(text, other.text, t),
      subtext: Color.lerp(subtext, other.subtext, t),
    );
  }
}

extension ThemeGetter on BuildContext {
  MyColors get colors => Theme.of(this).extension<MyColors>()!;
}
