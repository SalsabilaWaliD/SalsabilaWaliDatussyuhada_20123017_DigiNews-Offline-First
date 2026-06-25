import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class FetchArticlesEvent extends NewsEvent {
  final String category;

  const FetchArticlesEvent({this.category = 'technology'});

  @override
  List<Object?> get props => [category];
}

class RefreshArticlesEvent extends NewsEvent {
  final String category;

  const RefreshArticlesEvent({this.category = 'technology'});

  @override
  List<Object?> get props => [category];
}
