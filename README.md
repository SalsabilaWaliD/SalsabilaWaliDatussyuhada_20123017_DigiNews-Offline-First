# 📰 DigiNews Offline-First

**Enterprise Smart Dashboard** — UAS Mobile Programming Lanjut  
Universitas Teknologi Digital

---

## 👤 Identitas
| Field | Value |
|-------|-------|
| **Nama** | Salsabila Wali Datussyuhada |
| **NIM** | 20123017 |
| **Tema** | DigiNews Offline-First |
| **Mata Kuliah** | Mobile Programming Lanjut |

---

## 🏗️ Arsitektur

Proyek ini menggunakan **Clean Architecture** dengan pemisahan 3 layer:

```
lib/
├── core/                    # Shared utilities
│   ├── di/                  # Dependency Injection (get_it)
│   ├── network/             # Dio client + Interceptors
│   ├── router/              # go_router navigation
│   └── theme/               # App theme (DEV vs PROD)
├── data/                    # Data layer
│   ├── datasources/
│   │   ├── local/           # Isar database
│   │   └── remote/          # NewsAPI via Dio
│   ├── models/              # ArticleModel (Isar collection)
│   └── repositories/        # Repository implementation
├── domain/                  # Business logic layer
│   ├── entities/            # Article entity (pure Dart)
│   ├── repositories/        # Abstract interfaces
│   └── usecases/            # GetArticlesUseCase
└── presentation/            # UI layer
    ├── bloc/                # NewsBloc (BLoC pattern)
    ├── pages/               # home, detail, about
    └── widgets/             # ArticleCard, OfflineBanner
```

---

## ✅ Checklist Spesifikasi Teknis

### 1. Arsitektur & Environment 
- [x] **Clean Architecture** — layer terpisah: data, domain, presentation
- [x] **go_router** — navigasi `/`, `/detail`, `/about`
- [x] **get_it** — dependency injection di `core/di/injection.dart`
- [x] **2 Flavors** via `--dart-define=FLAVOR=dev/prod`
  - DEV: nama app `"DEV - Salsabila"`, warna bebas (teal)
  - PROD: nama app `"UTD - 20123017"`, warna **Biru Gelap**

### 2. Networking & State Management (20%)
- [x] **Dio** dengan 2 Interceptor: `LoggingInterceptor` + `ErrorInterceptor`
- [x] **BLoC** dengan state: `NewsInitial`, `NewsLoading`, `NewsLoaded`, `NewsError`
- [x] **🔥 Anti-AI Sorting di Repository** (BUKAN di UI):
  - NIM `20123017` → digit terakhir `7` → **GANJIL** → Sort **Z ke A (Descending)**
  - File: `lib/data/repositories/news_repository_impl.dart` → method `_sortArticlesDescending()`

### 3. Isar Database & Lottie 
- [x] **Isar** — cache artikel dari API, fallback saat offline
- [x] **OfflineBanner** — muncul saat Airplane Mode, menampilkan data cache
- [x] **🔥 Easter Egg Lottie** di halaman About:
  - Klik foto profil **7 kali** (= digit terakhir NIM) secara cepat
  - Animasi Lottie muncul memenuhi layar selama **3 detik**

### 4. Native Integration / MethodChannel 
- [x] **MethodChannel** `"com.salsabila.diginews/native"`
- [x] **🔥 Kotlin membalik NIM**: `"20123017"` → `"71032102"`
- [x] **Native Toast Android** menampilkan hasil reversed NIM
- [x] File Kotlin: `android/app/src/main/kotlin/com/salsabila/diginews/MainActivity.kt`

### 5. Testing & CI/CD 
- [x] **3+ Unit Tests** menggunakan Mocktail:
  - `test/data/news_repository_test.dart` — sorting logic + offline fallback
  - `test/presentation/bloc/news_bloc_test.dart` — BLoC state transitions
  - `test/data/get_articles_usecase_test.dart` — UseCase delegation
- [x] **GitHub Actions** (`.github/workflows/ci_cd.yml`):
  - Job 1: Run unit tests
  - Job 2: Build APK DEV Release → upload artifact
  - Job 3: Build APK PROD Release → upload artifact
- [x] **Minimal 20 commits** di minimal 3 hari berbeda (lakukan secara manual!)

---

## 🚀 Cara Menjalankan

### Prerequisites
- Flutter SDK 3.10+
- Android Studio / VS Code
- Akun [NewsAPI.org](https://newsapi.org/register)

### Setup

1. **Clone repository**
```bash
git clone https://github.com/[username]/diginews.git
cd diginews
```

2. **Isi API Key** di `lib/data/datasources/remote/news_remote_datasource.dart`:
```dart
static const String _apiKey = 'GANTI_DENGAN_API_KEY_KAMU';
```

3. **Install dependencies**
```bash
flutter pub get
```

4. **Generate Isar schema**
```bash
dart run build_runner build --delete-conflicting-outputs
```

5. **Download Lottie JSON** dan taruh di `assets/lottie/easter_egg.json`  
   Contoh dari LottieFiles: https://lottiefiles.com/animations/celebration

6. **Run versi DEV**
```bash
flutter run --flavor dev --dart-define=FLAVOR=dev -t lib/main.dart
```

7. **Run versi PROD**
```bash
flutter run --flavor prod --dart-define=FLAVOR=prod -t lib/main.dart
```

### Build APK

```bash
# DEV APK
flutter build apk --release --flavor dev --dart-define=FLAVOR=dev -t lib/main.dart

# PROD APK
flutter build apk --release --flavor prod --dart-define=FLAVOR=prod -t lib/main.dart
```

### Run Tests

```bash
flutter test
```

