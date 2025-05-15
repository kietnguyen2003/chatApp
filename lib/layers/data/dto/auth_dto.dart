class AuthDto {
  final String token;
  final String refreshToken;
  final String user;

  AuthDto({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthDto.fromJson(Map<String, dynamic> json) {
    return AuthDto(
      token: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user_id'],
    );
  }
}
