class UserData {
  final String id;
  final String name;
  final String? avatarUrl;

  UserData({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'], // عدل المفتاح حسب API فعلي
    );
  }
}
