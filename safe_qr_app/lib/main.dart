import 'package:flutter/material.dart';
import 'package:safe_qr_app/core/initialization/app_initialization.dart';
import 'package:safe_qr_app/core/my_app.dart';

Future<void> main() async {
  await AppInitialization.initialize();
  runApp(const MyApp());
}
