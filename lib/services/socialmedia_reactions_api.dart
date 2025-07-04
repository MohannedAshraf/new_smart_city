// services/socialmedia_reactions_api.dart

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:citio/models/impression_model.dart';
import 'package:citio/core/utils/variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SocialMediaReactionsApi {
  static Future<ImpressionsCount?> sendReaction({
    required String postId,
    required String reactionType,
  }) async {
    print('➡️ Sending reaction "$reactionType" for postId: $postId');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) return null;

    try {
      final response = await http.post(
        Uri.parse('${Urls.socialmediaBaseUrl}/api/posts/$postId/reactions'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'reactionType': reactionType}),
      );
      print('⬅️ Response status: ${response.statusCode}');
      print('⬅️ Response body: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final countMap = decoded['post']?['impressionsCount'];
        if (countMap != null) {
          int total = 0;
          for (var key in ['like', 'love', 'care', 'laugh', 'sad', 'hate']) {
            total +=
                (countMap[key] is num) ? (countMap[key] as num).toInt() : 0;
          }
          countMap['total'] = total;

          print('✅ Computed total: $total');

          return ImpressionsCount.fromJson(countMap);
        }
      } else {
        print('❌ Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in sending reaction: $e');
    }

    return null;
  }
}
