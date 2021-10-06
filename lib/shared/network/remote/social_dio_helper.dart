import 'package:dio/dio.dart';

class SocialDioHelper
{
  static late Dio dio;


  static init() {
    dio = Dio(
      BaseOptions(
          baseUrl: 'https://fcm.googleapis.com/fcm/send',
          receiveDataWhenStatusError: true,
          connectTimeout:8000,
          receiveTimeout: 8000,
          headers: {
            'Content-Type':'application/json',
            'Authorization': 'key=AAAAShdMQ5g:APA91bETqn4Yiev9XtYH8CwbDqxd-2hsGcYNJrTo_bIEiqAEeSOI6H_PDqoHfX5l-IwHuKAPEYnVVYGoGxJwifAt9VUwZIzrKfG1saTDp4eHPbEGseLl4DZLRcZDKA24t_CBgfVOtkDQ'
          }

      ),
    );
  }


  static Future<Response> postData({
     String url='https://fcm.googleapis.com/fcm/send',
    required Map<String,dynamic> data,
    String? token

  }) async
  {
    return await dio.post(
        url,
        data:data
    );
  }


}
