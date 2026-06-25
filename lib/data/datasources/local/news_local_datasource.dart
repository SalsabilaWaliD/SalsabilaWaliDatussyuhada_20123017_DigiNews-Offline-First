import 'package:isar/isar.dart';
import '../../models/article_model.dart';

abstract class NewsLocalDataSource {
  Future<List<ArticleModel>> getCachedArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
  Future<void> clearCache();
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final Isar isar;

  NewsLocalDataSourceImpl(this.isar);

  @override
  Future<List<ArticleModel>> getCachedArticles() async {
    return await isar.articleModels.where().findAll();
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    await isar.writeTxn(() async {
      // Hapus cache lama dulu
      await isar.articleModels.clear();
      // Simpan data baru
      await isar.articleModels.putAll(articles);
    });
  }

  @override
  Future<void> clearCache() async {
    await isar.writeTxn(() async {
      await isar.articleModels.clear();
    });
  }
}
