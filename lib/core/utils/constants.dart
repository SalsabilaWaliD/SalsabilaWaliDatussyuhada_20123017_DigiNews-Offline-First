class AppConstants {
  // NIM & Info Mahasiswa
  static const String nim = '20123017';
  static const String namaDepan = 'Salsabila';
  static const String namaLengkap = 'Salsabila Wali Datussyuhada';

  // Digit terakhir NIM = 7 (Ganjil) -> Sort Z ke A
  static const int nimLastDigit = 7;

  // Easter Egg: klik sebanyak digit terakhir NIM
  static const int easterEggClickTarget = 7;

  // MethodChannel name - harus sama antara Dart dan Kotlin
  static const String methodChannelName = 'com.salsabila.diginews/native';

  // App Names
  static const String appNameDev = 'DEV - Salsabila';
  static const String appNameProd = 'UTD - 20123017';

  // NewsAPI - ganti dengan API key dari newsapi.org (gratis)
  static const String newsApiBaseUrl = 'https://newsapi.org/v2/';
  static const String newsApiKey = '6a010536def24fe38c36fd141b3765b6';

  // Default category
  static const String defaultCategory = 'technology';

  // Easter egg duration
  static const int easterEggDurationSeconds = 3;
}
