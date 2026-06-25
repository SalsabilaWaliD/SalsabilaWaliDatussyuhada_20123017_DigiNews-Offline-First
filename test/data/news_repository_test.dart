import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:diginews/data/datasources/local/news_local_datasource.dart';
import 'package:diginews/data/datasources/remote/news_remote_datasource.dart';
import 'package:diginews/data/models/article_model.dart';
import 'package:diginews/data/repositories/news_repository_impl.dart';

// Mock classes menggunakan Mocktail
class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

class MockNewsLocalDataSource extends Mock implements NewsLocalDataSource {}

// Helper membuat ArticleModel palsu
ArticleModel _makeArticle(String title) {
  final m = ArticleModel();
  m.title = title;
  m.description = 'Desc for $title';
  return m;
}

void main() {
  late NewsRepositoryImpl repository;
  late MockNewsRemoteDataSource mockRemote;
  late MockNewsLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockNewsRemoteDataSource();
    mockLocal = MockNewsLocalDataSource();
    repository = NewsRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('NewsRepositoryImpl - Sorting Logic (NIM 20123017, digit=7, Ganjil = Z→A)',
      () {
    test('Articles should be sorted Z to A (descending) by title', () async {
      // Arrange: data tidak terurut
      final unsortedArticles = [
        _makeArticle('Apple releases new iPhone'),
        _makeArticle('Zoom reports record earnings'),
        _makeArticle('Meta announces layoffs'),
        _makeArticle('Bitcoin hits new high'),
      ];

      when(() => mockRemote.getTopHeadlines(
            category: any(named: 'category'),
          )).thenAnswer((_) async => unsortedArticles);
      when(() => mockLocal.cacheArticles(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getTopHeadlines();

      // Assert: harus urut Z ke A
      final titles = result.map((a) => a.title).toList();
      expect(titles[0], contains('Zoom')); // Z - paling pertama
      expect(titles[1], contains('Meta')); // M
      expect(titles[2], contains('Bitcoin')); // B
      expect(titles[3], contains('Apple')); // A - paling terakhir

      // Verifikasi urutan benar-benar descending
      for (int i = 0; i < titles.length - 1; i++) {
        expect(
          titles[i].compareTo(titles[i + 1]),
          greaterThanOrEqualTo(0),
          reason:
              'Title[$i]="${titles[i]}" harus >= Title[${i + 1}]="${titles[i + 1]}"',
        );
      }
    });

    test('Empty list from API should return empty list', () async {
      // Arrange
      when(() => mockRemote.getTopHeadlines(
            category: any(named: 'category'),
          )).thenAnswer((_) async => []);
      when(() => mockLocal.cacheArticles(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getTopHeadlines();

      // Assert
      expect(result, isEmpty);
    });

    test('Single article should be returned as-is', () async {
      // Arrange
      final singleArticle = [_makeArticle('Only Article')];

      when(() => mockRemote.getTopHeadlines(
            category: any(named: 'category'),
          )).thenAnswer((_) async => singleArticle);
      when(() => mockLocal.cacheArticles(any())).thenAnswer((_) async {});

      // Act
      final result = await repository.getTopHeadlines();

      // Assert
      expect(result.length, 1);
      expect(result.first.title, 'Only Article');
    });
  });

  group('NewsRepositoryImpl - Offline Fallback to Isar Cache', () {
    test('Should return cached articles when remote fails (offline)', () async {
      // Arrange: remote throw error (simulasi offline)
      when(() => mockRemote.getTopHeadlines(
            category: any(named: 'category'),
          )).thenThrow(Exception('No internet connection'));

      final cachedArticles = [
        _makeArticle('Cached Article Z'),
        _makeArticle('Cached Article A'),
      ];
      when(() => mockLocal.getCachedArticles())
          .thenAnswer((_) async => cachedArticles);

      // Act
      final result = await repository.getTopHeadlines();

      // Assert: hasil dari cache tetap ada
      expect(result.length, 2);
      // Dan tetap terurut Z ke A
      expect(result[0].title, 'Cached Article Z');
      expect(result[1].title, 'Cached Article A');
    });

    test('Should throw when offline AND no cache available', () async {
      // Arrange
      when(() => mockRemote.getTopHeadlines(
            category: any(named: 'category'),
          )).thenThrow(Exception('No internet'));
      when(() => mockLocal.getCachedArticles())
          .thenAnswer((_) async => []);

      // Act & Assert
      expect(
        () => repository.getTopHeadlines(),
        throwsA(isA<Exception>()),
      );
    });

    test('Should cache articles after successful fetch', () async {
      // Arrange
      final articles = [_makeArticle('New Article')];

      when(() => mockRemote.getTopHeadlines(
            category: any(named: 'category'),
          )).thenAnswer((_) async => articles);
      when(() => mockLocal.cacheArticles(any())).thenAnswer((_) async {});

      // Act
      await repository.getTopHeadlines();

      // Assert: cacheArticles harus dipanggil
      verify(() => mockLocal.cacheArticles(any())).called(1);
    });
  });
}
