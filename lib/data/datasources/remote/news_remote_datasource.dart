import 'package:dio/dio.dart';
import '../../models/article_model.dart';
import '../../../core/utils/constants.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    String category = AppConstants.defaultCategory,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;

  NewsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    String category = AppConstants.defaultCategory,
  }) async {
    final response = await dio.get(
      'top-headlines',
      queryParameters: {
        'apiKey': AppConstants.newsApiKey,
        'category': category,
        'country': 'us',
        'pageSize': 30,
      },
    );

    final List<dynamic> articles =
        (response.data['articles'] as List<dynamic>?) ?? [];
    return articles
        .where((a) =>
            a['title'] != null &&
            a['title'] != '[Removed]' &&
            a['title'] != 'null')
        .map((a) => ArticleModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }
}
