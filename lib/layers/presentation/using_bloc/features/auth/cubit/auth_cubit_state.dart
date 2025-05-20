part of 'auth_cubit_cubit.dart';

sealed class AuthCubitState extends Equatable {
  const AuthCubitState();

  @override
  List<Object> get props => [];
}

final class AuthCubitInitial extends AuthCubitState {}

final class AuthCubitLoading extends AuthCubitState {}

final class AuthCubitSuccess extends AuthCubitState {
  final String message;

  const AuthCubitSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AuthCubitError extends AuthCubitState {
  final String error;

  const AuthCubitError(this.error);

  @override
  List<Object> get props => [error];
}

final class AuthCubitLoggedIn extends AuthCubitState {
  final String accessToken;
  final String refreshToken;

  const AuthCubitLoggedIn(this.accessToken, this.refreshToken);

  @override
  List<Object> get props => [accessToken, refreshToken];
}
