import 'package:city/helper/api.dart';
import 'package:city/models/socialmedia_post.dart';

class GetPost {
  Future<SocialmediaPost> getTenPosts() async {
    // ignore: missing_required_param
    dynamic data = await Api().get(
      url: 'https://graduation.amiralsayed.me/api/posts/?scope=user&limit=10',
      token:
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXJhbHNheWVkLndvcmtAZ21haWwuY29tIiwibmFtZWlkIjoiODNkN2UyYWEtMWFiYS00ZWEzLTgzODUtZDIxN2IxYTNhMDU4IiwidW5pcXVlX25hbWUiOiJhbWlyYWxzYXllZC53b3JrMzg3Mzg1MTc3NSIsInJvbGUiOiJNb2JpbGVVc2VyIiwibmJmIjoxNzQ1NzEzNDUwLCJleHAiOjE3NDU3MTQzNTAsImlhdCI6MTc0NTcxMzQ1MCwiaXNzIjoiQ2VudHJhbFVzZXJNYW5hZ2VtZW50U2VydmljZSIsImF1ZCI6IkNlbnRyYWxVc2VyTWFuYWdlbWVudFNlcnZpY2UifQ.PYPTxwhJpP7BryRl_jnMm-mxbtUO8Zq_MaiDpJdpBmCFlvZHAgshOEwMK6cr3OJrRP91EoxZox-398GSVxoeDQ',
    );
    SocialmediaPost posts = (SocialmediaPost.fromJason(data));
    /* for (int i = 0; i < data.length; i++) {
      posts.add(SocialmediaPost.fromJason(data[i]));
    }*/
    return posts;
  }
}
