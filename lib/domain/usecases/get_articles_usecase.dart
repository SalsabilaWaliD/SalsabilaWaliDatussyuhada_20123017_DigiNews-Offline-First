import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetArticlesUseCase {
  final NewsRepository repository;

  GetArticlesUseCase(this.repository);

  Future<List<Article>> call({String category = 'technology'}) async {
    return await repository.getTopHeadlines(category: category);
  }
}
