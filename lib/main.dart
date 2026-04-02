import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:maidconnect/firebase_options.dart';

import 'app/app.dart';

/// Entry point of the application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Launch the main application widget
  runApp(const MaidConnectApp());
}
