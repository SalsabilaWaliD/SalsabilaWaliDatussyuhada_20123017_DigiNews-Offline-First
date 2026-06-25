import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_articles_usecase.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetArticlesUseCase getArticlesUseCase;

  NewsBloc({required this.getArticlesUseCase}) : super(const NewsInitial()) {
    on<FetchArticlesEvent>(_onFetchArticles);
    on<RefreshArticlesEvent>(_onRefreshArticles);
  }

  Future<void> _onFetchArticles(
    FetchArticlesEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(const NewsLoading());
    await _loadArticles(event.category, emit);
  }

  Future<void> _onRefreshArticles(
    RefreshArticlesEvent event,
    Emitter<NewsState> emit,
  ) async {
    // Refresh tanpa show loading (UX lebih smooth)
    await _loadArticles(event.category, emit);
  }

  Future<void> _loadArticles(
    String category,
    Emitter<NewsState> emit,
  ) async {
    try {
      // Gunakan .call() secara eksplisit agar testable dengan mocktail
      final articles = await getArticlesUseCase.call(category: category);

      if (articles.isEmpty) {
        emit(const NewsError(message: 'No articles found.'));
      } else {
        emit(NewsLoaded(articles: articles));
      }
    } catch (e) {
      emit(NewsError(message: 'Failed to load news: ${e.toString()}'));
    }
  }
}
