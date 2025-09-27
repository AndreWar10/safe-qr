import 'package:flutter/material.dart';
import 'package:safe_qr_app/core/my_app.dart';
import 'package:safe_qr_app/injection.dart' as injection;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injection.configureDependencies();
  runApp(const MyApp());
}