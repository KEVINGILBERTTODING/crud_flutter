import 'package:crud_flutter/modules/auth/views/login.dart';
import 'package:crud_flutter/modules/home/home.dart';
import 'package:crud_flutter/providers/auth/auth_provider.dart';
import 'package:crud_flutter/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      home: Consumer(builder: (context, ref, child) {
        // check apakah ada data atau tidak
        final authCheck = ref.watch(authCheckProvider);
        return authCheck.when(
          data: (authenticated) {
            if (authenticated) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
          error: (error, stackTrace) => const Text('Anda tidak memiliki akses'),
          loading: () => const CircularProgressIndicator(),
        );
      }),
      routes: AppRoutes.routes,
    );
  }
}
