import 'package:flutter/widgets.dart';
import 'package:safe_qr_app/injection.dart' as injection;

class AppInitialization {
  const AppInitialization._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await injection.configureDependencies();
  }
}

