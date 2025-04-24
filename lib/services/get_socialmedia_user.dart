import 'package:city/helper/api.dart';

import 'package:city/models/socialmedia_user.dart';

class GetSocialmediaUser {
  Future<SocialmediaUser> getSocialMediaUser({required String id}) async {
    dynamic data = await Api().get(
      url: 'https://graduation.amiralsayed.me/api/users/$id',
      token:
          'eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImFtaXJhbHNheWVkLndvcmtAZ21haWwuY29tIiwibmFtZWlkIjoiODNkN2UyYWEtMWFiYS00ZWEzLTgzODUtZDIxN2IxYTNhMDU4IiwidW5pcXVlX25hbWUiOiJhbWlyYWxzYXllZC53b3JrMzg3Mzg1MTc3NSIsInJvbGUiOiJNb2JpbGVVc2VyIiwibmJmIjoxNzQ1NDcwMTI0LCJleHAiOjE3NDU0NzEwMjQsImlhdCI6MTc0NTQ3MDEyNCwiaXNzIjoiQ2VudHJhbFVzZXJNYW5hZ2VtZW50U2VydmljZSIsImF1ZCI6IkNlbnRyYWxVc2VyTWFuYWdlbWVudFNlcnZpY2UifQ.YgoNOiwIi4RRMKxtd0leh3QKeXbEbeRROEHwVrxQ5zS2DdXK8nRc-u4kIhF_zXkyhy5F91yCVI2DgQdtaDXwig',
    );
    SocialmediaUser user = SocialmediaUser.fromJason(data);
    return user;
  }
}
