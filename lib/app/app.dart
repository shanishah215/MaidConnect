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
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
