String baseUrl = 'https://graduation.amiralsayed.me';

class SocialmediaUser {
  final String userName;
  final String name;
  final String? avatar;
  SocialmediaUser({required this.userName, required this.name, this.avatar});
  factory SocialmediaUser.fromJason(jsonData) {
    return SocialmediaUser(
      userName: jsonData['userName'],
      name: jsonData['localUserName'],
      avatar: baseUrl + jsonData['avatarUrl'],
    );
  }
}

/*
class SocialmediaUser {
  final String? id;
  final String? centralUsrId;
  final String? userName;
  final String? localUserName;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final List<String>? friends; // Changed from List<Null>
  final List<String>? posts;
  final List<String>? savedPosts;
  final List<SharedPosts>? sharedPosts;
  final String? createdAt;
  final String? updatedAt;
  final int? version;
  final String? coverUrl;
  final String? role;

  SocialmediaUser({
    this.id,
    this.centralUsrId,
    this.userName,
    this.localUserName,
    this.email,
    this.avatarUrl,
    this.bio,
    this.friends,
    this.posts,
    this.savedPosts,
    this.sharedPosts,
    this.createdAt,
    this.updatedAt,
    this.version,
    this.coverUrl,
    this.role,
  });

  factory SocialmediaUser.fromJson(Map<String, dynamic> json) {
    return SocialmediaUser(
      id: json['_id'] as String?,
      centralUsrId: json['centralUsrId'] as String?,
      userName: json['userName'] as String?,
      localUserName: json['localUserName'] as String?,
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      friends:
          json['friends'] != null ? List<String>.from(json['friends']) : null,
      posts: json['posts'] != null ? List<String>.from(json['posts']) : null,
      savedPosts:
          json['savedPosts'] != null
              ? List<String>.from(json['savedPosts'])
              : null,
      sharedPosts:
          json['sharedPosts'] != null
              ? List<SharedPosts>.from(
                json['sharedPosts'].map((x) => SharedPosts.fromJson(x)),
              )
              : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      version: json['__v'] as int?,
      coverUrl: json['coverUrl'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'centralUsrId': centralUsrId,
      'userName': userName,
      'localUserName': localUserName,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'friends': friends,
      'posts': posts,
      'savedPosts': savedPosts,
      'sharedPosts': sharedPosts?.map((x) => x.toJson()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': version,
      'coverUrl': coverUrl,
      'role': role,
    };
  }
}

class SharedPosts {
  final String? shareCaption;
  final String? id;
  final Buffer? buffer;
  final String? postId;

  SharedPosts({this.shareCaption, this.id, this.buffer, this.postId});

  factory SharedPosts.fromJson(Map<String, dynamic> json) {
    return SharedPosts(
      shareCaption: json['shareCaption'] as String?,
      id: json['_id'] as String?,
      buffer: json['buffer'] != null ? Buffer.fromJson(json['buffer']) : null,
      postId: json['postId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shareCaption': shareCaption,
      '_id': id,
      'buffer': buffer?.toJson(),
      'postId': postId,
    };
  }
}

class Buffer {
  final String? type;
  final List<int>? data;

  Buffer({this.type, this.data});

  factory Buffer.fromJson(Map<String, dynamic> json) {
    return Buffer(
      type: json['type'] as String?,
      data:
          json['data'] != null
              ? List<int>.from(json['data'].map((x) => x as int))
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'data': data};
  }
}*/
