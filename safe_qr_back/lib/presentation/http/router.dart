import 'package:logging/logging.dart';
import 'package:safe_qr_back/presentation/http/controllers/analyze_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRouter {
  AppRouter({
    AnalyzeController? analyzeController,
    Logger? logger,
  }) : _analyzeController = analyzeController ??
            AnalyzeController(
              logger: logger,
            );

  final AnalyzeController _analyzeController;

  Router build() {
    final router = Router();

    router.get('/health', (request) => Response.ok('ok'));
    router.post('/api/v1/analyze', _analyzeController.handle);

    return router;
  }
}
