import 'package:equatable/equatable.dart';

class Auth with EquatableMixin {
  final String? accessToken;
  final String? refreshToken;
  final String? userId;

  const Auth({this.accessToken, this.refreshToken, this.userId});

  @override
  List<Object?> get props => [accessToken, refreshToken, userId];
}
