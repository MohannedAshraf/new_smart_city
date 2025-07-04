import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ApiPostHelper {
  static const String _baseUrl = "https://graduation.amiralsayed.me/api/posts";

  static Future<String?> createNewPost({
    required String postCaption,
    required List<XFile> mediaFiles,
  }) async {
  

    if (postCaption.length < 3 || postCaption.length > 1000) {
      return 'نص المنشور يجب أن يكون بين 3 و 1000 حرف';
    }

    if (mediaFiles.length > 5) {
      return 'يمكنك رفع 5 صور كحد أقصى';
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return "التوكن غير موجود";
    }

    try {
      final uri = Uri.parse(_baseUrl);
      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['postCaption'] = postCaption;

      for (var file in mediaFiles) {
        final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
        final mimeParts = mimeType.split('/');

        var multipartFile = await http.MultipartFile.fromPath(
          'media',
          file.path,
          contentType: MediaType(mimeParts[0], mimeParts[1]),
          filename: file.name,
        );

        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);


      if (response.statusCode == 200 || response.statusCode == 201) {
        return null;
      } else {
        return 'خطأ ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'حدث استثناء: $e';
    }
  }
}
