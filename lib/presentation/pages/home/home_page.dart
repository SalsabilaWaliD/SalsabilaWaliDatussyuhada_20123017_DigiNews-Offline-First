import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injection.dart';
import '../../../domain/entities/article.dart';
import '../../bloc/news/news_bloc.dart';
import '../../bloc/news/news_event.dart';
import '../../bloc/news/news_state.dart';
import '../../widgets/article_card.dart';
import '../../widgets/offline_banner.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsBloc>()..add(const FetchArticlesEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  String _selectedCategory = 'technology';

  final List<String> _categories = [
    'technology',
    'business',
    'sports',
    'health',
    'science',
    'entertainment',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DigiNews',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'About',
            onPressed: () => context.push('/about'),
          ),
          BlocBuilder<NewsBloc, NewsState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: () {
                  context.read<NewsBloc>().add(
                        RefreshArticlesEvent(category: _selectedCategory),
                      );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category chips
          _buildCategoryBar(),
          // Offline banner
          const OfflineBanner(),
          // News list
          Expanded(
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is NewsError) {
                  return _buildError(state.message, context);
                }
                if (state is NewsLoaded) {
                  return _buildArticleList(state.articles, state.isFromCache, context);
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = cat == _selectedCategory;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                cat[0].toUpperCase() + cat.substring(1),
                style: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _selectedCategory = cat);
                context.read<NewsBloc>().add(FetchArticlesEvent(category: cat));
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildArticleList(List<Article> articles, bool isFromCache, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsBloc>().add(
              RefreshArticlesEvent(category: _selectedCategory),
            );
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return ArticleCard(
            article: article,
            onTap: () => context.push('/detail', extra: {'article': article}),
          );
        },
      ),
    );
  }

  Widget _buildError(String message, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<NewsBloc>().add(
                      FetchArticlesEvent(category: _selectedCategory),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
