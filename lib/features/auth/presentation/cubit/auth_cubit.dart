import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cougar_app/features/auth/data/models/user_model.dart';
import 'package:cougar_app/features/auth/data/repositories/auth_repository_impl.dart';

part 'auth_cubit.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(UserModel user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthState.initial());

  Future<void> checkAuth() async {
    emit(const AuthState.loading());
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    final user = await _authRepository.login(email, password);
    if (user != null) {
      emit(AuthState.authenticated(user));
    } else {
      emit(const AuthState.error('Invalid email or password'));
    }
  }

  Future<void> register(String name, String email, String password, String question, String answer) async {
    emit(const AuthState.loading());
    try {
      final user = await _authRepository.register(name, email, password, question, answer);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthState.unauthenticated());
  }
}
