import 'package:intl/intl.dart';
import 'package:citio/core/utils/variables.dart';

class SocialmediaPost {
  List<Data> data;
  String message;

  SocialmediaPost({required this.data, required this.message});

  factory SocialmediaPost.fromJson(
    Map<String, dynamic> jsonData,
    String currentUserId,
  ) {
    return SocialmediaPost(
      data:
          (jsonData['data'] as List<dynamic>?)
              ?.map((x) => Data.fromJson(x, currentUserId))
              .toList() ??
          [],
      message: jsonData['message'] ?? '',
    );
  }
}

class Data {
  String? id;
  String? authorId;
  String? postCaption;
  String? createdAt;
  bool adminPost;
  List<Media>? media;
  List<String?>? tags;
  ImpressionsCount? impressionsCount;
  int saveCount;
  String? userReaction;

  Data({
    this.id,
    this.authorId,
    this.postCaption,
    this.createdAt,
    this.adminPost = false,
    this.media,
    this.tags,
    this.impressionsCount,
    this.saveCount = 0,
    this.userReaction,
  });

  factory Data.fromJson(Map<String, dynamic> json, String currentUserId) {
    String? detectedReaction;

    if (json['impressionList'] != null) {
      for (var item in json['impressionList']) {
        if (item['userId'] == currentUserId) {
          detectedReaction = item['impressionType'];
          break;
        }
      }
    }

    return Data(
      id: json['_id'] as String?,
      authorId: json['author'] as String?,
      postCaption: json['postCaption'] as String?,
      createdAt: json['createdAt'] as String?,
      adminPost: json['adminPost'] ?? false,
      media:
          (json['media'] as List<dynamic>?)
              ?.map((item) => Media.fromJson(item))
              .toList(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String?>(),
      impressionsCount:
          json['impressionsCount'] != null
              ? ImpressionsCount.fromJson(json['impressionsCount'])
              : null,
      saveCount: json['saveCount'] ?? 0,
      userReaction: detectedReaction,
    );
  }
}

class Media {
  final String? type;
  final String? url;
  final String? sId;

  Media({this.type, this.url, this.sId});

  factory Media.fromJson(Map<String, dynamic> jsonData) {
    return Media(
      type: jsonData['type'] as String?,
      url:
          jsonData['url'] != null
              ? Urls.socialmediaBaseUrl + (jsonData['url'] as String)
              : null,
      sId: jsonData['_id'] as String?,
    );
  }
}

class ImpressionsCount {
  int? like;
  int? love;
  int? care;
  int? laugh;
  int? sad;
  int? hate;

  ImpressionsCount({
    this.like,
    this.love,
    this.care,
    this.laugh,
    this.sad,
    this.hate,
  });

  factory ImpressionsCount.fromJson(Map<String, dynamic> jsonData) {
    return ImpressionsCount(
      like: jsonData['like'] as int? ?? 0,
      love: jsonData['love'] as int? ?? 0,
      care: jsonData['care'] as int? ?? 0,
      laugh: jsonData['laugh'] as int? ?? 0,
      sad: jsonData['sad'] as int? ?? 0,
      hate: jsonData['hate'] as int? ?? 0,
    );
  }

  int get total {
    return (like ?? 0) +
        (love ?? 0) +
        (care ?? 0) +
        (laugh ?? 0) +
        (sad ?? 0) +
        (hate ?? 0);
  }
}

String getTimeAgo(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) {
      return 'منذ ${diff.inSeconds} ثانية';
    } else if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return DateFormat.yMMMMd('ar_EG').format(date);
    }
  } catch (_) {
    return 'تاريخ غير صالح';
  }
}
