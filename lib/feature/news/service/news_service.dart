import 'package:diyar_app/core/api/api_paths.dart';
import 'package:diyar_app/core/constants/custom_logger.dart';
import 'package:diyar_app/core/helper/dio_helper.dart';
import 'package:diyar_app/core/model/news_response_model.dart';
import 'package:diyar_app/feature/news/model/news_details_response_model.dart';

class NewsService {
  static Future<NewsResponseModel> getAllNews() async {
    final newsResponsePath = await DioHelper.getData(path: ApiPaths.getAllNews);
    AppLogger.info("newsResponsePath==>$newsResponsePath");
    try {
      if (newsResponsePath != null && newsResponsePath.statusCode == 200) {
        return NewsResponseModel.fromJson(newsResponsePath.data);
      }
    } catch (e) {
      AppLogger.error("Error Happen While Get All News is $e");
    }
    return NewsResponseModel.fromJson(newsResponsePath?.data);
  }

  static Future<NewsDetailsResponseModel> getNewsDetails({
    required String id,
  }) async {
    final newsResponsePath = await DioHelper.getData(
      path: ApiPaths.newsDetails(id: id),
    );
    AppLogger.info("newsDetailsResponsePath==>$newsResponsePath");
    try {
      if (newsResponsePath != null && newsResponsePath.statusCode == 200) {
        return NewsDetailsResponseModel.fromJson(newsResponsePath.data);
      }
    } catch (e) {
      AppLogger.error("Error Happen While Get News Details is $e");
    }
    return NewsDetailsResponseModel.fromJson(newsResponsePath?.data);
  }
}
