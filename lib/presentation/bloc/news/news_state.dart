import 'package:equatable/equatable.dart';
import '../../../domain/entities/article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NewsInitial extends NewsState {
  const NewsInitial();
}

/// Loading state
class NewsLoading extends NewsState {
  const NewsLoading();
}

/// Success state dengan data artikel
class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool isFromCache;

  const NewsLoaded({
    required this.articles,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [articles, isFromCache];
}

/// Error state
class NewsError extends NewsState {
  final String message;

  const NewsError({required this.message});

  @override
  List<Object?> get props => [message];
}
