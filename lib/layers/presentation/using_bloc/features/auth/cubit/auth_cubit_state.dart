part of 'auth_cubit_cubit.dart';

abstract class AuthCubitState extends Equatable {
  const AuthCubitState();

  @override
  List<Object> get props => [];
}

class AuthCubitInitial extends AuthCubitState {}

class AuthCubitLoading extends AuthCubitState {}

class AuthCubitSuccess extends AuthCubitState {
  final String message;

  const AuthCubitSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AuthCubitError extends AuthCubitState {
  final String error;

  const AuthCubitError(this.error);

  @override
  List<Object> get props => [error];
}

class AuthCubitLoggedIn extends AuthCubitState {
  final Auth auth;

  const AuthCubitLoggedIn(this.auth);

  @override
  List<Object> get props => [auth];
}
