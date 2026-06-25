import '../entities/article.dart';

abstract class NewsRepository {
  /// Mengambil artikel dari API atau cache lokal
  Future<List<Article>> getTopHeadlines({String category = 'technology'});
}
