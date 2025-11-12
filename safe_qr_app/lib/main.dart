import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safe_qr_app/core/my_app.dart';
import 'package:safe_qr_app/injection.dart' as injection;

Future<void> main() async {
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
