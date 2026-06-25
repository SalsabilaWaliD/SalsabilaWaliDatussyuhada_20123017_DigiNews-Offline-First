import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';

import '../../data/datasources/local/news_local_datasource.dart';
import '../../data/datasources/remote/news_remote_datasource.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/repositories/news_repository.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../presentation/bloc/news/news_bloc.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

void setupDependencies(Isar isar) {
  // External
  sl.registerSingleton<Isar>(isar);
  sl.registerSingleton<Dio>(DioClient.createDio());

  // DataSources
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<NewsLocalDataSource>(
    () => NewsLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetArticlesUseCase(sl()));

  // BLoC
  sl.registerFactory(() => NewsBloc(getArticlesUseCase: sl()));
}
