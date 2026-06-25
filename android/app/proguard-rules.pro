# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

# Isar Database
-keep class dev.isar.** { *; }
-dontwarn dev.isar.**

# Keep our MainActivity
-keep class com.salsabila.diginews.** { *; }

# Dio & OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**
