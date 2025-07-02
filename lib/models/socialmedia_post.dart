// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:citio/core/utils/variables.dart';

class SocialmediaPost {
  List<Data> data;
  String message;

  SocialmediaPost({
    required this.data,
    required this.message,
  });

  factory SocialmediaPost.fromJason(Map<String, dynamic> jsonData) {
    return SocialmediaPost(
      data: (jsonData['data'] as List<dynamic>?)
              ?.map((x) => Data.fromJson(x))
              .toList() ??
          [],
      message: jsonData['message'] ?? '',
    );
  }
}

class Data {
  String? id;            // من _id
  String? authorId;      // من author (بدل userId)
  String? postCaption;   // من postCaption (بدل caption)
  String? createdAt;     // من createdAt (بدل dateIssued)
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

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['_id'] as String?,
      authorId: json['author'] as String?,
      postCaption: json['postCaption'] as String?,
      createdAt: json['createdAt'] as String?,
      adminPost: json['adminPost'] ?? false,
      media: (json['media'] as List<dynamic>?)
          ?.map((item) => Media.fromJson(item))
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.cast<String?>(),
      impressionsCount: json['impressionsCount'] != null
          ? ImpressionsCount.fromJson(json['impressionsCount'])
          : null,
      saveCount: json['saveCount'] ?? 0,
      userReaction: json['userReaction'], // حسب وجودها في JSON
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
      url: jsonData['url'] != null
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
  int? total;

  ImpressionsCount({
    this.like,
    this.love,
    this.care,
    this.laugh,
    this.sad,
    this.hate,
    this.total,
  });

  factory ImpressionsCount.fromJson(Map<String, dynamic> jsonData) {
    return ImpressionsCount(
      like: jsonData['like'] as int?,
      love: jsonData['love'] as int?,
      care: jsonData['care'] as int?,
      laugh: jsonData['laugh'] as int?,
      sad: jsonData['sad'] as int?,
      hate: jsonData['hate'] as int?,
      total: jsonData['total'] as int?,
    );
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
