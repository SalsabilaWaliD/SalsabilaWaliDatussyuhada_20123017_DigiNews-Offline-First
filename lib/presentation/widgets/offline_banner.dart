import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineBanner extends StatefulWidget {
  const OfflineBanner({super.key});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  bool _isOffline = false;

  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();

    _checkConnectivity();

    _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (mounted) {
          setState(() {
            _isOffline = result == ConnectivityResult.none;
          });
        }
      },
    );
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();

    if (mounted) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      color: Colors.orange[700],
      child: const Row(
        children: [
          Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'You\'re offline — showing cached news',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}