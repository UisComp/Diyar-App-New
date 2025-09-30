import 'dart:developer';

import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/news_response_model.dart';

class NewsService {
  static Future<NewsResponseModel> getAllNews() async {
    final newsResponsePath = await DioHelper.getData(path: ApiPaths.getAllNews);
    log("newsResponsePath==>$newsResponsePath");
    try {
      if (newsResponsePath != null && newsResponsePath.statusCode == 200) {
        return NewsResponseModel.fromJson(newsResponsePath.data);
      }
    } catch (e) {
      log("Error Happen While Get All News is $e");
    }
    return NewsResponseModel.fromJson(newsResponsePath?.data);
  }
}
