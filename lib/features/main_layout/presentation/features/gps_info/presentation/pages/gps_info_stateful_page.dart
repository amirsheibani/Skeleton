import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeleton/core/di/base/di_setup.dart';

class GPSInfoStatefulPage extends StatefulWidget {
  const GPSInfoStatefulPage({super.key});

  @override
  State<GPSInfoStatefulPage> createState() => _GPSInfoStatefulPageState();
}

class _GPSInfoStatefulPageState extends State<GPSInfoStatefulPage> {
  late final GPSService _gpsService;

  StreamSubscription<GPSLocationInfo>? _locationInfoSub;
  StreamSubscription<Position>? _positionSub;

  GPSPermissionStatus _permissionStatus = GPSPermissionStatus.checking;
  Position? _currentPosition;
  GPSLocationInfo? _locationInfo;
  bool _isListening = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _gpsService = getIt<GPSService>();
    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _permissionStatus = await _gpsService.requestPermission();
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'خطا در مقداردهی اولیه: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    if (_permissionStatus != GPSPermissionStatus.granted) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Permission برای GPS داده نشده است';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _gpsService.getCurrentPosition();
      final locationInfo = position != null ? await _gpsService.getLocationInfo() : null;

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _locationInfo = locationInfo;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'خطا در دریافت موقعیت: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getLastKnownPosition() async {
    if (_permissionStatus != GPSPermissionStatus.granted) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Permission برای GPS داده نشده است';
      });
      return;
    }

    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _gpsService.getLastKnownPosition();
      final locationInfo = position != null ? await _gpsService.getLastKnownLocationInfo() : null;

      if (!mounted) return;
      setState(() {
        _currentPosition = position;
        _locationInfo = locationInfo;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'خطا در دریافت آخرین موقعیت: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _startListening() async {
    if (_permissionStatus != GPSPermissionStatus.granted) {
      setState(() {
        _errorMessage = 'Permission برای GPS داده نشده است';
      });
      return;
    }

    try {
      final started = await _gpsService.startListening(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      if (!started) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'نتوانست GPS listening را شروع کند';
        });
        return;
      }

      // Listen to location info stream
      _locationInfoSub = _gpsService.locationInfoStream.listen((locationInfo) {
        if (!mounted) return;
        setState(() {
          _currentPosition = locationInfo.position;
          _locationInfo = locationInfo;
        });
      });

      // Also listen to position stream as backup
      _positionSub = _gpsService.positionStream.listen((position) {
        if (!mounted) return;
        setState(() {
          _currentPosition = position;
        });
      });

      if (!mounted) return;
      setState(() {
        _isListening = true;
        _errorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'خطا در شروع listening: $e';
      });
    }
  }

  Future<void> _stopListening() async {
    await _locationInfoSub?.cancel();
    _locationInfoSub = null;
    await _positionSub?.cancel();
    _positionSub = null;
    await _gpsService.stopListening();

    // Get last known position after stopping
    final lastPosition = await _gpsService.getLastKnownPosition();
    final lastLocationInfo = lastPosition != null ? await _gpsService.getLastKnownLocationInfo() : null;

    if (!mounted) return;
    setState(() {
      _isListening = false;
      _currentPosition = lastPosition;
      _locationInfo = lastLocationInfo;
    });
  }

  @override
  void dispose() {
    _locationInfoSub?.cancel();
    _positionSub?.cancel();
    _gpsService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Service Example (Stateful)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // وضعیت Permission
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('وضعیت Permission', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Text('loading...')
                    else
                      Text('$_permissionStatus'),
                    const SizedBox(height: 8),
                    _buildPermissionStatusChip(_permissionStatus),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // نمایش خطا
            if (_errorMessage != null)
              Card(
                color: Colors.red.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_errorMessage != null) const SizedBox(height: 16),

            // دکمه‌های عملیات
            if (_permissionStatus == GPSPermissionStatus.granted) ...[
              _buildActionButton(
                'گرفتن موقعیت فعلی',
                Icons.my_location,
                _getCurrentPosition,
                color: Colors.green,
                enabled: !_isListening && !_isLoading,
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                'گرفتن آخرین موقعیت',
                Icons.location_searching,
                _getLastKnownPosition,
                color: Colors.orange,
                enabled: !_isListening && !_isLoading,
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                _isListening ? 'توقف Listening' : 'شروع Listening',
                _isListening ? Icons.stop : Icons.play_arrow,
                _isListening ? _stopListening : _startListening,
                color: _isListening ? Colors.red : Colors.purple,
                enabled: !_isLoading,
              ),
            ],

            const SizedBox(height: 24),

            // نمایش موقعیت
            if (_isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (_currentPosition != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('موقعیت فعلی', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      _buildInfoRow('Latitude', _currentPosition!.latitude.toStringAsFixed(6)),
                      _buildInfoRow('Longitude', _currentPosition!.longitude.toStringAsFixed(6)),
                      _buildInfoRow('Accuracy', '${_currentPosition!.accuracy.toStringAsFixed(2)} متر'),
                      _buildInfoRow('Altitude', '${_currentPosition!.altitude.toStringAsFixed(2)} متر'),
                      _buildInfoRow('Speed', '${_currentPosition!.speed.toStringAsFixed(2)} m/s'),
                      _buildInfoRow('Heading', '${_currentPosition!.heading.toStringAsFixed(2)}°'),
                      _buildInfoRow('Timestamp', _currentPosition!.timestamp.toString()),
                    ],
                  ),
                ),
              ),
              if (_locationInfo != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'اطلاعات منبع موقعیت',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          'منبع / Source',
                          _locationInfo!.sourceDescription,
                        ),
                        _buildInfoRow(
                          'GPS Service',
                          _locationInfo!.isLocationServiceEnabled ? 'فعال / Enabled' : 'غیرفعال / Disabled',
                        ),
                        _buildInfoRow(
                          'دقت / Accuracy',
                          '${_locationInfo!.accuracyMeters.toStringAsFixed(2)} متر',
                        ),
                        _buildSourceChip(_locationInfo!.source),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStatusChip(GPSPermissionStatus permissionStatus) {
    Color color;
    String text;

    switch (permissionStatus) {
      case GPSPermissionStatus.granted:
        color = Colors.green;
        text = 'Granted';
        break;
      case GPSPermissionStatus.denied:
        color = Colors.orange;
        text = 'Denied';
        break;
      case GPSPermissionStatus.deniedForever:
        color = Colors.red;
        text = 'Denied Forever';
        break;
      case GPSPermissionStatus.checking:
        color = Colors.grey;
        text = 'Checking...';
        break;
    }

    return Chip(
      label: Text(text),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed, {Color? color, bool enabled = true}) {
    return ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSourceChip(GPSLocationSource source) {
    Color color;
    IconData icon;

    switch (source) {
      case GPSLocationSource.gps:
        color = Colors.green;
        icon = Icons.satellite;
        break;
      case GPSLocationSource.network:
        color = Colors.blue;
        icon = Icons.wifi;
        break;
      case GPSLocationSource.passive:
        color = Colors.orange;
        icon = Icons.cached;
        break;
      case GPSLocationSource.unknown:
        color = Colors.grey;
        icon = Icons.help_outline;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Chip(
        avatar: Icon(icon, color: color, size: 20),
        label: Text(
          source.toString().split('.').last.toUpperCase(),
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color.withOpacity(0.1),
      ),
    );
  }
}

