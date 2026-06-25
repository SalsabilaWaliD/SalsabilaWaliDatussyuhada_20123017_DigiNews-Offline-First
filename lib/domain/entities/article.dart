import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final int? id;
  final String title;
  final String? description;
  final String? content;
  final String? url;
  final String? urlToImage;
  final String? author;
  final String? sourceName;
  final DateTime? publishedAt;

  const Article({
    this.id,
    required this.title,
    this.description,
    this.content,
    this.url,
    this.urlToImage,
    this.author,
    this.sourceName,
    this.publishedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        url,
        urlToImage,
        author,
        sourceName,
        publishedAt,
      ];
}
