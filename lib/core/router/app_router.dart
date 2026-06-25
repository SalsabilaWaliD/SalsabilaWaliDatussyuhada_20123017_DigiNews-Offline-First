import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/article.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/detail/detail_page.dart';
import '../../presentation/pages/about/about_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final extra = state.extra;
          if (extra == null || extra is! Map<String, dynamic>) {
            return const Scaffold(
              body: Center(child: Text('Article not found')),
            );
          }
          final article = extra['article'];
          if (article == null || article is! Article) {
            return const Scaffold(
              body: Center(child: Text('Invalid article data')),
            );
          }
          return DetailPage(article: article);
        },
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutPage(),
      ),
    ],
  );
}
