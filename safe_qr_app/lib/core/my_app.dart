import 'package:flutter/material.dart';
import 'package:safe_qr_app/core/router/app_router.dart';
import 'package:safe_qr_app/core/router/app_routes.dart';
import 'package:safe_qr_app/core/theme/presentation/widgets/theme_wrapper.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      child: MaterialApp(
        title: 'Safe QR App',
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRoutes.home,
      ),
    );
  }
}