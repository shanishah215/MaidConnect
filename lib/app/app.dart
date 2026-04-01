import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'router/app_routes.dart';

class MaidConnectApp extends StatelessWidget {
  const MaidConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaidConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1F4F99)),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
