// ignore_for_file: prefer_interpolation_to_compose_strings

class SocialmediaUser {
  final String userName;
  final String name;
  final String? avatar;
  SocialmediaUser({required this.userName, required this.name, this.avatar});
  factory SocialmediaUser.fromJason(jsonData) {
    return SocialmediaUser(
      userName: '@' + jsonData['userName'],
      name: jsonData['localUserName'],
      avatar: jsonData['avatarUrl'],
    );
  }
}
