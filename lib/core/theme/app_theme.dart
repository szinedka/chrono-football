import 'package:flutter/material.dart';

class AppTheme {
  static const Color _lcdGreen = Color(0xFF97D95C);

  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: _lcdGreen,
      secondary: Color(0xFF4FAE57),
      surface: Color(0xFF101410),
    );

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFF070A07),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(fontFamily: 'monospace'),
      ),
    );
  }
}
