// models/socialmedia_user_minimal.dart

import 'package:citio/core/utils/variables.dart';

class SocialmediaUserMinimal {
  final String localUserName;
  final String? avatarUrl;

  SocialmediaUserMinimal({
    required this.localUserName,
    this.avatarUrl,
  });

  factory SocialmediaUserMinimal.fromJson(Map<String, dynamic> json) {
    return SocialmediaUserMinimal(
      localUserName: json['localUserName'] ?? '',
      avatarUrl: json['avatarUrl'] != null
          ? Urls.socialmediaBaseUrl + json['avatarUrl']
          : null,
    );
  }
}
