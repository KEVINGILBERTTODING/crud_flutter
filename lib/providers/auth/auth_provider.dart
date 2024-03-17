import 'package:crud_flutter/repositories/auth/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final authCheckProvider = FutureProvider<bool>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.checkAuth();
});

final dataUsernameProvider = FutureProvider<String>((ref) async {
  final authRepository = ref.read(authRepositoryProvider);
  return authRepository.getUsername();
});
