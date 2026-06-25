import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:diginews/domain/entities/article.dart';
import 'package:diginews/domain/usecases/get_articles_usecase.dart';
import 'package:diginews/presentation/bloc/news/news_bloc.dart';
import 'package:diginews/presentation/bloc/news/news_event.dart';
import 'package:diginews/presentation/bloc/news/news_state.dart';

// Mock UseCase - karena GetArticlesUseCase menggunakan call() method,
// kita perlu mock class-nya langsung
class MockGetArticlesUseCase extends Mock implements GetArticlesUseCase {}

// Dummy Article untuk testing
const _dummyArticle = Article(
  title: 'Test Article Z',
  description: 'Test description',
  sourceName: 'Test Source',
);

void main() {
  late NewsBloc newsBloc;
  late MockGetArticlesUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetArticlesUseCase();
    newsBloc = NewsBloc(getArticlesUseCase: mockUseCase);
  });

  tearDown(() {
    newsBloc.close();
  });

  group('NewsBloc - State Transitions', () {
    test('Initial state should be NewsInitial', () {
      expect(newsBloc.state, const NewsInitial());
    });

    blocTest<NewsBloc, NewsState>(
      'Should emit [NewsLoading, NewsLoaded] when FetchArticlesEvent succeeds',
      build: () {
        when(() => mockUseCase.call(category: any(named: 'category')))
            .thenAnswer((_) async => [_dummyArticle]);
        return NewsBloc(getArticlesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchArticlesEvent()),
      expect: () => [
        const NewsLoading(),
        isA<NewsLoaded>().having(
          (s) => s.articles,
          'articles',
          isNotEmpty,
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'Should emit [NewsLoading, NewsError] when FetchArticlesEvent fails',
      build: () {
        when(() => mockUseCase.call(category: any(named: 'category')))
            .thenThrow(Exception('Network error'));
        return NewsBloc(getArticlesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchArticlesEvent()),
      expect: () => [
        const NewsLoading(),
        isA<NewsError>(),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'Should emit [NewsLoading, NewsError] when articles list is empty',
      build: () {
        when(() => mockUseCase.call(category: any(named: 'category')))
            .thenAnswer((_) async => []);
        return NewsBloc(getArticlesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchArticlesEvent()),
      expect: () => [
        const NewsLoading(),
        isA<NewsError>().having(
          (s) => s.message,
          'message',
          contains('No articles'),
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'Should emit NewsLoaded with correct articles count',
      build: () {
        final articles = List.generate(
          5,
          (i) => Article(title: 'Article ${5 - i}', description: 'Desc $i'),
        );
        when(() => mockUseCase.call(category: any(named: 'category')))
            .thenAnswer((_) async => articles);
        return NewsBloc(getArticlesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchArticlesEvent()),
      expect: () => [
        const NewsLoading(),
        isA<NewsLoaded>().having(
          (s) => s.articles.length,
          'articles.length',
          5,
        ),
      ],
    );

    blocTest<NewsBloc, NewsState>(
      'RefreshArticlesEvent should NOT emit NewsLoading first (smooth UX)',
      build: () {
        when(() => mockUseCase.call(category: any(named: 'category')))
            .thenAnswer((_) async => [_dummyArticle]);
        return NewsBloc(getArticlesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const RefreshArticlesEvent()),
      expect: () => [
        // No NewsLoading for refresh!
        isA<NewsLoaded>(),
      ],
    );
  });

  group('NewsBloc - Category Filtering', () {
    blocTest<NewsBloc, NewsState>(
      'FetchArticlesEvent with category should pass category to usecase',
      build: () {
        when(() => mockUseCase.call(category: 'sports'))
            .thenAnswer((_) async => [_dummyArticle]);
        return NewsBloc(getArticlesUseCase: mockUseCase);
      },
      act: (bloc) => bloc.add(const FetchArticlesEvent(category: 'sports')),
      expect: () => [
        const NewsLoading(),
        isA<NewsLoaded>(),
      ],
      verify: (_) {
        verify(() => mockUseCase.call(category: 'sports')).called(1);
      },
    );
  });
}
