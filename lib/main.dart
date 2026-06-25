import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/article_model.dart';

// --dart-define=FLAVOR=dev  atau  --dart-define=FLAVOR=prod
const String _flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
const String _appName =
    _flavor == 'prod' ? 'UTD - 20123017' : 'DEV - Salsabila';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init Isar Database
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ArticleModelSchema],
    directory: dir.path,
    name: 'diginews_db',
  );

  // Init Dependency Injection
  setupDependencies(isar);

  runApp(DigiNewsApp(flavor: _flavor));
}

class DigiNewsApp extends StatelessWidget {
  final String flavor;
  const DigiNewsApp({super.key, required this.flavor});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: _appName,
      debugShowCheckedModeBanner: flavor == 'dev',
      theme: AppTheme.getTheme(flavor),
      routerConfig: AppRouter.router,
    );
  }
}
