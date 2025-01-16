import "package:flutter/material.dart";

class MyMaterialTheme {
  final TextTheme textTheme;

  const MyMaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff904a43),
      surfaceTint: Color(0xff904a43),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffffdad6),
      onPrimaryContainer: Color(0xff3b0907),
      secondary: Color(0xff775652),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffffdad6),
      onSecondaryContainer: Color(0xff2c1512),
      tertiary: Color(0xff715b2e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfffddfa6),
      onTertiaryContainer: Color(0xff261900),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff231918),
      onSurfaceVariant: Color(0xff534341),
      outline: Color(0xff857371),
      outlineVariant: Color(0xffd8c2bf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2d),
      inversePrimary: Color(0xffffb4ab),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff3b0907),
      primaryFixedDim: Color(0xffffb4ab),
      onPrimaryFixedVariant: Color(0xff73332d),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff2c1512),
      secondaryFixedDim: Color(0xffe7bdb8),
      onSecondaryFixedVariant: Color(0xff5d3f3c),
      tertiaryFixed: Color(0xfffddfa6),
      onTertiaryFixed: Color(0xff261900),
      tertiaryFixedDim: Color(0xffe0c38c),
      onTertiaryFixedVariant: Color(0xff574419),
      surfaceDim: Color(0xffe8d6d4),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae7),
      surfaceContainerHigh: Color(0xfff6e4e2),
      surfaceContainerHighest: Color(0xfff1dedc),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6e302a),
      surfaceTint: Color(0xff904a43),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffaa6057),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff593b38),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff8f6c68),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff534015),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff897142),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff231918),
      onSurfaceVariant: Color(0xff4f3f3d),
      outline: Color(0xff6c5b59),
      outlineVariant: Color(0xff897674),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2d),
      inversePrimary: Color(0xffffb4ab),
      primaryFixed: Color(0xffaa6057),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff8d4841),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff8f6c68),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff745450),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff897142),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff6e592c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d4),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae7),
      surfaceContainerHigh: Color(0xfff6e4e2),
      surfaceContainerHighest: Color(0xfff1dedc),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff44100c),
      surfaceTint: Color(0xff904a43),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff6e302a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff341c19),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff593b38),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff2e2000),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff534015),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffff8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff2e211f),
      outline: Color(0xff4f3f3d),
      outlineVariant: Color(0xff4f3f3d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff392e2d),
      inversePrimary: Color(0xffffe7e4),
      primaryFixed: Color(0xff6e302a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff521a16),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff593b38),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff402623),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff534015),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff3b2a02),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffe8d6d4),
      surfaceBright: Color(0xfffff8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfffff0ee),
      surfaceContainer: Color(0xfffceae7),
      surfaceContainerHigh: Color(0xfff6e4e2),
      surfaceContainerHighest: Color(0xfff1dedc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb4ab),
      surfaceTint: Color(0xffffb4ab),
      onPrimary: Color(0xff561e19),
      primaryContainer: Color(0xff73332d),
      onPrimaryContainer: Color(0xffffdad6),
      secondary: Color(0xffe7bdb8),
      onSecondary: Color(0xff442926),
      secondaryContainer: Color(0xff5d3f3c),
      onSecondaryContainer: Color(0xffffdad6),
      tertiary: Color(0xffe0c38c),
      onTertiary: Color(0xff3f2e04),
      tertiaryContainer: Color(0xff574419),
      onTertiaryContainer: Color(0xfffddfa6),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff1a1110),
      onSurface: Color(0xfff1dedc),
      onSurfaceVariant: Color(0xffd8c2bf),
      outline: Color(0xffa08c8a),
      outlineVariant: Color(0xff534341),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dedc),
      inversePrimary: Color(0xff904a43),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff3b0907),
      primaryFixedDim: Color(0xffffb4ab),
      onPrimaryFixedVariant: Color(0xff73332d),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff2c1512),
      secondaryFixedDim: Color(0xffe7bdb8),
      onSecondaryFixedVariant: Color(0xff5d3f3c),
      tertiaryFixed: Color(0xfffddfa6),
      onTertiaryFixed: Color(0xff261900),
      tertiaryFixedDim: Color(0xffe0c38c),
      onTertiaryFixedVariant: Color(0xff574419),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3231),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffbab1),
      surfaceTint: Color(0xffffb4ab),
      onPrimary: Color(0xff330404),
      primaryContainer: Color(0xffcc7b72),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffebc1bc),
      onSecondary: Color(0xff26100d),
      secondaryContainer: Color(0xffad8883),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffe4c790),
      onTertiary: Color(0xff1f1400),
      tertiaryContainer: Color(0xffa78d5b),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1110),
      onSurface: Color(0xfffff9f9),
      onSurfaceVariant: Color(0xffdcc6c3),
      outline: Color(0xffb39e9c),
      outlineVariant: Color(0xff927f7c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dedc),
      inversePrimary: Color(0xff74352e),
      primaryFixed: Color(0xffffdad6),
      onPrimaryFixed: Color(0xff2c0101),
      primaryFixedDim: Color(0xffffb4ab),
      onPrimaryFixedVariant: Color(0xff5e231e),
      secondaryFixed: Color(0xffffdad6),
      onSecondaryFixed: Color(0xff200b09),
      secondaryFixedDim: Color(0xffe7bdb8),
      onSecondaryFixedVariant: Color(0xff4b2f2c),
      tertiaryFixed: Color(0xfffddfa6),
      onTertiaryFixed: Color(0xff191000),
      tertiaryFixedDim: Color(0xffe0c38c),
      onTertiaryFixedVariant: Color(0xff453309),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3231),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffff9f9),
      surfaceTint: Color(0xffffb4ab),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffbab1),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffff9f9),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffebc1bc),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffffaf7),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe4c790),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff1a1110),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffff9f9),
      outline: Color(0xffdcc6c3),
      outlineVariant: Color(0xffdcc6c3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xfff1dedc),
      inversePrimary: Color(0xff4e1813),
      primaryFixed: Color(0xffffe0dc),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffbab1),
      onPrimaryFixedVariant: Color(0xff330404),
      secondaryFixed: Color(0xffffe0dc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffebc1bc),
      onSecondaryFixedVariant: Color(0xff26100d),
      tertiaryFixed: Color(0xffffe3b1),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe4c790),
      onTertiaryFixedVariant: Color(0xff1f1400),
      surfaceDim: Color(0xff1a1110),
      surfaceBright: Color(0xff423735),
      surfaceContainerLowest: Color(0xff140c0b),
      surfaceContainerLow: Color(0xff231918),
      surfaceContainer: Color(0xff271d1c),
      surfaceContainerHigh: Color(0xff322826),
      surfaceContainerHighest: Color(0xff3d3231),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
