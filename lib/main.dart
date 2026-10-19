
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/quiz_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const QuiznovaApp());
}

class QuiznovaApp extends StatelessWidget {
  const QuiznovaApp({super.key});

  static const blue = Color(0xFF0284C7);
  static const indigo = Color(0xFF4F46E5);
  static const purple = Color(0xFF7C3AED);

  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [blue, indigo, purple],
  );

  ThemeData _buildTheme(Brightness brightness) {
    final dark = brightness == Brightness.dark;

    const lightBackground = Color(0xFFF8FAFC);
    const lightSurface = Colors.white;
    const lightText = Color(0xFF0F172A);
    const lightBorder = Color(0xFFE2E8F0);

    const darkBackground = Color(0xFF020617);
    const darkSurface = Color(0xFF0F172A);
    const darkText = Color(0xFFF1F5F9);
    const darkBorder = Color(0xFF263449);

    final background = dark ? darkBackground : lightBackground;
    final surface = dark ? darkSurface : lightSurface;
    final text = dark ? darkText : lightText;
    final border = dark ? darkBorder : lightBorder;
    final secondaryText =
        dark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    OutlineInputBorder inputBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: blue,
        brightness: brightness,
        primary: blue,
        secondary: purple,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      canvasColor: background,
      cardColor: surface,
      dividerColor: border,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        dark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
      ).apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: dark ? 0 : 1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF1E293B) : lightBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: secondaryText,
          fontSize: 13,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: secondaryText,
          fontSize: 13,
        ),
        border: inputBorder(border),
        enabledBorder: inputBorder(border),
        focusedBorder: inputBorder(blue, 1.6),
        errorBorder: inputBorder(const Color(0xFFEF4444)),
        focusedErrorBorder: inputBorder(
          const Color(0xFFEF4444),
          1.6,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: blue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: border,
          disabledForegroundColor: secondaryText,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: text,
          side: BorderSide(color: border),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: dark
              ? const Color(0xFF38BDF8)
              : blue,
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      iconTheme: IconThemeData(color: secondaryText),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: text,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: secondaryText,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: border),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor:
            dark ? const Color(0xFF334155) : lightText,
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontSize: 13,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: dark ? const Color(0xFF38BDF8) : blue,
        linearTrackColor: border,
      ),
    );

    return baseTheme;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider()..loadHistory(),
      child: Consumer<QuizProvider>(
        builder: (context, quizProvider, _) {
          return MaterialApp(
            title: 'Quiznova',
            debugShowCheckedModeBanner: false,
            themeMode: quizProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            theme: _buildTheme(Brightness.light),
            darkTheme: _buildTheme(Brightness.dark),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
