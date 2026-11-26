
import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.phone, required this.password});
  final String phone;
  final String password;

  @override
  List<Object?> get props => [phone, password];
}

final class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  final String phone;
  final String password;
  final String firstName;
  final String lastName;
  final String email;

  @override
  List<Object?> get props => [phone, password, firstName, lastName, email];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
