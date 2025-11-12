import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safe_qr_app/injection.dart' as injection;

class AppInitialization {
  const AppInitialization._();

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: 'assets/.env');
    _validateEnvironment();
    await injection.configureDependencies();
  }

  static void _validateEnvironment() {
    final apiUrl = dotenv.env['SAFE_QR_API_URL']?.trim();
    if (apiUrl == null || apiUrl.isEmpty) {
      throw Exception(
        'Variável de ambiente obrigatória SAFE_QR_API_URL não configurada. '
        'Atualize o arquivo assets/.env antes de iniciar o aplicativo.',
      );
    }
  }
}

