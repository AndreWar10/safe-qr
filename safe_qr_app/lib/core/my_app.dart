import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_qr_app/core/router/app_router.dart';
import 'package:safe_qr_app/core/router/app_routes.dart';
import 'package:safe_qr_app/core/theme/presentation/widgets/theme_wrapper.dart';
import 'package:safe_qr_app/core/theme/presentation/bloc/theme_bloc.dart';
import 'package:safe_qr_app/core/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:safe_qr_app/features/scan_qr/presentation/cubit/scan_qr_cubit.dart';
import 'package:safe_qr_app/injection.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeWrapper(
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Safe QR App',
            debugShowCheckedModeBanner: false,
            theme: Theme.of(context),
            onGenerateRoute: AppRouter.generateRoute,
            initialRoute: AppRoutes.home,
            builder: (context, child) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<ThemeBloc>(),
                  ),
                  BlocProvider(
                    create: (_) => getIt<NavigationCubit>(),
                  ),
                  BlocProvider(
                    create: (_) => getIt<ScanQrCubit>(),
                  ),
                ],
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}