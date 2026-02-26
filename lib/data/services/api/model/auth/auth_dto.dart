class AuthDto {
  final String token;

  AuthDto.fromJson(Map<String, dynamic> json) : token = json['token'];
}
