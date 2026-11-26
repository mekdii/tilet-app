import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tilet/features/auth/data/repositories/auth_repository.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_event.dart';
import 'package:tilet/features/auth/presentation/bloc/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthRepository? repository})
      : _repository = repository ?? AuthRepository(),
        super(const AuthState()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _repository;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final loggedIn = await _repository.isLoggedIn();
    emit(state.copyWith(
      status: loggedIn ? AuthStatus.authenticated : AuthStatus.unauthenticated,
    ));
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _repository.login(phone: event.phone, password: event.password);
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _repository.register(
        phone: event.phone,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}