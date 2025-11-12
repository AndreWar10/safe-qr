import 'package:flutter/material.dart';
import 'package:safe_qr_app/core/router/app_routes.dart';
import 'package:safe_qr_app/core/navigation/presentation/components/app_shell.dart';
import 'package:safe_qr_app/features/settings/presentation/pages/local_database_status_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const AppShell());
      case AppRoutes.localDatabaseStatus:
        return MaterialPageRoute(builder: (_) => const LocalDatabaseStatusPage());
      // case AppRoutes.scanQr:
      //   return MaterialPageRoute(builder: (_) => const ScanPage());
      // case AppRoutes.scanResult:
      //   return MaterialPageRoute(builder: (_) => const ResultPage());
      // case AppRoutes.history:
      //   return MaterialPageRoute(builder: (_) => const HistoryPage());
      // case AppRoutes.generateQr:
      //   return MaterialPageRoute(builder: (_) => const GenerateQrPage());
      // case AppRoutes.myQrCodes:
      //   return MaterialPageRoute(builder: (_) => const MyQrCodesPage());
      // case AppRoutes.dashboard:
      //   return MaterialPageRoute(builder: (_) => const DashboardPage());
      // case AppRoutes.lists:
      //   return MaterialPageRoute(builder: (_) => const ListsPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Rota não encontrada'))),
        );
    }
  }
}
