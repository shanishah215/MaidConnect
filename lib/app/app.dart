import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'router/app_router.dart';

class MaidConnectApp extends StatelessWidget {
  const MaidConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configure global SaaS-style theme
    final baseTextTheme = Typography.material2021(
      platform: Theme.of(context).platform,
    ).black;
    final plusJakartaSansTheme = GoogleFonts.plusJakartaSansTextTheme(
      baseTextTheme,
    );

    return MaterialApp.router(
      title: 'MaidConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Sleek vibrant blue
        ),
        scaffoldBackgroundColor: const Color(
          0xFFF8FAFC,
        ), // Cool light gray background
        textTheme: plusJakartaSansTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8FAFC),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          color: Colors.white,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}
