import 'package:isar/isar.dart';
import '../../domain/entities/article.dart';

part 'article_model.g.dart';

@collection
class ArticleModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String title;
  String? description;
  String? content;
  String? url;
  String? urlToImage;
  String? author;
  String? sourceName;
  DateTime? publishedAt;

  ArticleModel();

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final model = ArticleModel();
    model.title = json['title'] ?? 'No Title';
    model.description = json['description'] as String?;
    model.content = json['content'] as String?;
    model.url = json['url'] as String?;
    model.urlToImage = json['urlToImage'] as String?;
    model.author = json['author'] as String?;
    model.sourceName = json['source']?['name'] as String?;
    model.publishedAt = json['publishedAt'] != null
        ? DateTime.tryParse(json['publishedAt'] as String)
        : null;
    return model;
  }

  /// Convert ke domain entity
  Article toEntity() {
    return Article(
      id: id,
      title: title,
      description: description,
      content: content,
      url: url,
      urlToImage: urlToImage,
      author: author,
      sourceName: sourceName,
      publishedAt: publishedAt,
    );
  }

  /// Convert dari domain entity
  static ArticleModel fromEntity(Article entity) {
    final model = ArticleModel();
    if (entity.id != null) model.id = entity.id!;
    model.title = entity.title;
    model.description = entity.description;
    model.content = entity.content;
    model.url = entity.url;
    model.urlToImage = entity.urlToImage;
    model.author = entity.author;
    model.sourceName = entity.sourceName;
    model.publishedAt = entity.publishedAt;
    return model;
  }
}
