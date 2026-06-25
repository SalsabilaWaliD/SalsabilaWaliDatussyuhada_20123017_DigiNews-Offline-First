import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:diginews/domain/entities/article.dart';
import 'package:diginews/domain/repositories/news_repository.dart';
import 'package:diginews/domain/usecases/get_articles_usecase.dart';

// Mock Repository
class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late GetArticlesUseCase useCase;
  late MockNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockNewsRepository();
    useCase = GetArticlesUseCase(mockRepository);
  });

  const testArticles = [
    Article(title: 'Zoom tops list', sourceName: 'TechNews'),
    Article(title: 'Apple innovates', sourceName: 'AppleInsider'),
  ];

  group('GetArticlesUseCase', () {
    test('Should call repository.getTopHeadlines with default category',
        () async {
      // Arrange
      when(() => mockRepository.getTopHeadlines(category: 'technology'))
          .thenAnswer((_) async => testArticles);

      // Act
      final result = await useCase();

      // Assert
      expect(result, testArticles);
      verify(() => mockRepository.getTopHeadlines(category: 'technology'))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('Should call repository.getTopHeadlines with given category',
        () async {
      // Arrange
      when(() => mockRepository.getTopHeadlines(category: 'sports'))
          .thenAnswer((_) async => testArticles);

      // Act
      final result = await useCase(category: 'sports');

      // Assert
      expect(result, testArticles);
      verify(() => mockRepository.getTopHeadlines(category: 'sports'))
          .called(1);
    });

    test('Should propagate exception from repository', () async {
      // Arrange
      when(() =>
              mockRepository.getTopHeadlines(category: any(named: 'category')))
          .thenThrow(Exception('Repo failed'));

      // Act & Assert
      expect(
        () async => useCase(),
        throwsA(isA<Exception>()),
      );
    });

    test('Should return empty list when repository returns empty', () async {
      // Arrange
      when(() =>
              mockRepository.getTopHeadlines(category: any(named: 'category')))
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
    });

    test('Articles from usecase should preserve entity integrity', () async {
      // Arrange
      final articles = [
        const Article(
          title: 'Test Title',
          description: 'Test Desc',
          author: 'Test Author',
          sourceName: 'Test Source',
          url: 'https://example.com',
        ),
      ];
      when(() =>
              mockRepository.getTopHeadlines(category: any(named: 'category')))
          .thenAnswer((_) async => articles);

      // Act
      final result = await useCase();

      // Assert: semua field harus intact
      expect(result.first.title, 'Test Title');
      expect(result.first.description, 'Test Desc');
      expect(result.first.author, 'Test Author');
      expect(result.first.sourceName, 'Test Source');
      expect(result.first.url, 'https://example.com');
    });
  });
}
