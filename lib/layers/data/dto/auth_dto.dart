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
    if (json['access_token'] == null ||
        json['refresh_token'] == null ||
        json['user_id'] == null) {
      throw Exception('Invalid auth response');
    }
    return AuthDto(
      token: json['access_token'],
      refreshToken: json['refresh_token'],
      user: json['user_id'],
    );
  }
}
