import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:yt_save/domain/appcolors.dart';

class NetworkAwareWidget extends StatefulWidget {
  final Widget child;
  const NetworkAwareWidget({required this.child, Key? key}) : super(key: key);

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  bool _hasInternet = true;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkInternetConnectivity();

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _handleConnectivityChange(results);
    });
  }

  Future<void> _checkInternetConnectivity() async {
    setState(() {
      _isChecking = true;
    });

    try {
      var connectivityResults = await Connectivity().checkConnectivity();
      bool hasNetworkConnection = connectivityResults.any((result) => result != ConnectivityResult.none);

      if (!hasNetworkConnection) {
        setState(() {
          _hasInternet = false;
          _isChecking = false;
        });
        return;
      }

      bool hasRealInternet = await _hasInternetAccess();

      setState(() {
        _hasInternet = hasRealInternet;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _hasInternet = false;
        _isChecking = false;
      });
    }
  }

  Future<bool> _hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e) {
      return false;
    }
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    _checkInternetConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking connection...'),
            ],
          ),
        ),
      );
    }

    if (!_hasInternet) {
      return Scaffold(
        backgroundColor: AppColors.background1,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No Internet Connection',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Please connect to WiFi or mobile data and try again.',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _checkInternetConnectivity,
                  child: Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}