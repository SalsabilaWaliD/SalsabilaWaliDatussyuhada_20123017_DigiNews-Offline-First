import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import '../../../core/utils/constants.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // TANTANGAN ANTI-AI: Easter Egg
  // NIM: 20123017 -> Digit terakhir = 7
  // User harus klik foto sebanyak 7 kali secara cepat
  // ============================================================
  int _clickCount = 0;
  bool _showEasterEgg = false;
  DateTime? _lastClickTime;

  // ============================================================
  // TANTANGAN ANTI-AI: MethodChannel
  // Kirim NIM ke Kotlin -> Kotlin balik string -> tampil Toast
  // ============================================================
  static const platform = MethodChannel(AppConstants.methodChannelName);
  String _reversedNim = '';
  bool _nimReversed = false;

  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  Future<void> _reverseNimViaNative() async {
    try {
      final String result = await platform.invokeMethod(
        'reverseNim',
        {'nim': AppConstants.nim},
      );
      setState(() {
        _reversedNim = result;
        _nimReversed = true;
      });
    } on PlatformException catch (e) {
      setState(() {
        _reversedNim = 'Error: ${e.message}';
        _nimReversed = true;
      });
    }
  }

  void _onProfilePhotoTap() {
    final now = DateTime.now();

    // Reset jika jeda antar klik > 1.5 detik
    if (_lastClickTime != null &&
        now.difference(_lastClickTime!).inMilliseconds > 1500) {
      _clickCount = 0;
    }
    _lastClickTime = now;
    _clickCount++;

    if (_clickCount < AppConstants.easterEggClickTarget) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppConstants.easterEggClickTarget - _clickCount} more taps...',
          ),
          duration: const Duration(milliseconds: 500),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (_clickCount >= AppConstants.easterEggClickTarget) {
      _clickCount = 0;
      _triggerEasterEgg();
    }
  }

  void _triggerEasterEgg() {
    setState(() => _showEasterEgg = true);
    _lottieController.reset();

    Future.delayed(
      Duration(seconds: AppConstants.easterEggDurationSeconds),
      () {
        if (mounted) setState(() => _showEasterEgg = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ===== Konten Utama =====
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // === Foto Profil (Easter Egg trigger) ===
                GestureDetector(
                  onTap: _onProfilePhotoTap,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 62,
                      backgroundColor: Color(0xFFE8EAF6),
                      child: Icon(Icons.person, size: 80, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tap photo ${AppConstants.easterEggClickTarget}x for a secret!',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(height: 20),

                // === Info Card ===
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          AppConstants.namaLengkap,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        _infoRow(Icons.badge, 'NIM', AppConstants.nim),
                        _infoRow(Icons.school, 'Mata Kuliah',
                            'Mobile Programming Lanjut'),
                        _infoRow(Icons.newspaper, 'Tema',
                            'DigiNews Offline-First'),
                        _infoRow(Icons.architecture, 'Arsitektur',
                            'Clean Architecture'),
                        _infoRow(Icons.storage, 'Database',
                            'Isar (Offline-First)'),
                        _infoRow(Icons.route, 'Navigation', 'go_router'),
                        _infoRow(Icons.psychology, 'State', 'BLoC Pattern'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // === MethodChannel Section ===
                Card(
                  elevation: 2,
                  color: Colors.deepPurple.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.developer_mode,
                                color: Colors.deepPurple),
                            const SizedBox(width: 8),
                            Text(
                              'Native Integration (Kotlin)',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tap tombol di bawah untuk mengirim NIM "${AppConstants.nim}" '
                          'ke Kotlin via MethodChannel.\n'
                          'Kotlin akan membalik string-nya dan menampilkan Native Toast.',
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _reverseNimViaNative,
                            icon: const Icon(Icons.android),
                            label: const Text('Reverse NIM via Kotlin'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        if (_nimReversed) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  // ignore: deprecated_member_use
                                  color: Colors.deepPurple.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('NIM Asli (dari Dart):',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                Text(
                                  AppConstants.nim,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                const SizedBox(height: 8),
                                const Text('Dibalik (dari Kotlin):',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                                Text(
                                  _reversedNim,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // ===== EASTER EGG OVERLAY (7 klik = digit terakhir NIM) =====
          if (_showEasterEgg)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _showEasterEgg = false),
                child: Container(
                  color: Colors.black87,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/easter_egg.json',
                        controller: _lottieController,
                        onLoaded: (composition) {
                          _lottieController
                            ..duration = composition.duration
                            ..forward();
                        },
                        width: MediaQuery.of(context).size.width * 0.85,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'You found the secret! 🎉',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'NIM: 20123017',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () =>
                            setState(() => _showEasterEgg = false),
                        child: const Text(
                          'Tap to close',
                          style: TextStyle(color: Colors.white60),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
