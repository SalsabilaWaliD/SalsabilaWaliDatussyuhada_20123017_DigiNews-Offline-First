import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/local/news_local_datasource.dart';
import '../datasources/remote/news_remote_datasource.dart';
import '../models/article_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Article>> getTopHeadlines({String category = 'technology'}) async {
    try {
      // Coba ambil dari API
      final remoteArticles = await remoteDataSource.getTopHeadlines(
        category: category,
      );

      // ============================================================
      // 🔥 TANTANGAN ANTI-AI: LOGIKA SORTING DI LAYER REPOSITORY
      // NIM: 20123017 → Digit terakhir = 7 (GANJIL)
      // Rule: Sort Z ke A (Descending)
      // PENTING: Sorting dilakukan di sini, BUKAN di UI/Widget
      // ============================================================
      final sorted = _sortArticlesDescending(remoteArticles);

      // Cache ke Isar
      await localDataSource.cacheArticles(sorted);

      return sorted.map((m) => m.toEntity()).toList();
    } catch (e) {
      // Jika gagal (offline/error), ambil dari cache Isar
      print('[Repository] Remote failed: $e → Falling back to local cache');
      final cachedArticles = await localDataSource.getCachedArticles();

      if (cachedArticles.isEmpty) {
        throw Exception('No internet connection and no cached data available.');
      }

      // Tetap sort cache juga secara konsisten
      final sorted = _sortArticlesDescending(cachedArticles);
      return sorted.map((m) => m.toEntity()).toList();
    }
  }

  /// Sort artikel dari Z ke A berdasarkan title (Descending)
  /// NIM 20123017 → digit terakhir 7 → GANJIL → Z ke A
  List<ArticleModel> _sortArticlesDescending(List<ArticleModel> articles) {
    final sorted = List<ArticleModel>.from(articles);
    sorted.sort((a, b) => b.title.compareTo(a.title));
    return sorted;
  }
}
