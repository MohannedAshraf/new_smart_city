String _baseUrl = 'https://graduation.amiralsayed.me';

class SocialmediaUser {
  final String userName;
  final String name;
  final String? avatar;
  SocialmediaUser({required this.userName, required this.name, this.avatar});
  factory SocialmediaUser.fromJason(jsonData) {
    return SocialmediaUser(
      userName: '@' + jsonData['userName'],
      name: jsonData['localUserName'],
      avatar: _baseUrl + jsonData['avatarUrl'],
    );
  }
}
