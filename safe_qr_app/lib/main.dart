import 'package:flutter/material.dart';
import 'package:safe_qr_app/core/initialization/app_initialization.dart';
import 'package:safe_qr_app/core/my_app.dart';

Future<void> main() async {
  await AppInitialization.initialize();
  
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: 'assets/.env',
    mergeWith: const {
      'SAFE_QR_API_URL': 'http://10.0.2.2:8080',
    },
  );
  await injection.configureDependencies();
  runApp(const MyApp());
}
