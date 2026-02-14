import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeleton/core/di/base/di_setup.dart';

class CarSlopeStatefulPage extends StatefulWidget {
  const CarSlopeStatefulPage({super.key});

  @override
  State<CarSlopeStatefulPage> createState() => _CarSlopeStatefulPageState();
}

class _CarSlopeStatefulPageState extends State<CarSlopeStatefulPage> {
  late final CarSlopeService _carSlopeService;
  late final GPSService _gpsService;
  late final MotionService _motionService;

  StreamSubscription<CarSlopeData>? _slopeSub;
  StreamSubscription<GPSLocationInfo>? _gpsInfoSub;
  StreamSubscription<MotionData>? _motionSub;

  CarSlopeData? _lastSlopeData;
  GPSLocationInfo? _lastGpsInfo;
  MotionData? _lastMotionData;
  bool _isListening = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carSlopeService = getIt<CarSlopeService>();
    _gpsService = getIt<GPSService>();
    _motionService = getIt<MotionService>();

    _initialize();
  }

  Future<void> _initialize() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Request GPS permission
      final permissionStatus = await _gpsService.requestPermission();

      if (permissionStatus != GPSPermissionStatus.granted) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'GPS permission داده نشده است. لطفاً permission را فعال کنید.';
          _isLoading = false;
        });
        return;
      }

      // Warm-up GPS
      final initialPosition = await _gpsService.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: 15,
      );

      if (initialPosition == null) {
        final lastPosition = await _gpsService.getLastKnownPosition();
        if (lastPosition == null) {
          if (!mounted) return;
          setState(() {
            _errorMessage = 'GPS فعال نیست یا نمی‌تواند موقعیت را دریافت کند.';
            _isLoading = false;
          });
          return;
        }
      }

      // Start GPS listening
      final gpsListeningStarted = await _gpsService.startListening(
        desiredAccuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );

      if (!gpsListeningStarted) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'نتوانست GPS listening را شروع کند';
          _isLoading = false;
        });
        return;
      }

      // Start listening to streams
      _startListening();

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _isListening = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'خطا در مقداردهی اولیه: $e';
        _isLoading = false;
      });
    }
  }

  void _startListening() {
    // Listen to slope stream
    _slopeSub = _carSlopeService.slopeStream.listen(
      (slopeData) {
        if (!mounted) return;
        setState(() {
          _lastSlopeData = slopeData;
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _errorMessage = 'خطا در دریافت داده: $error';
        });
      },
    );

    // Listen to GPS location info
    _gpsInfoSub = _gpsService.locationInfoStream.listen((info) {
      if (!mounted) return;
      setState(() {
        _lastGpsInfo = info;
      });
    });

    // Listen to motion data
    _motionSub = _motionService.motionStream.listen((data) {
      if (!mounted) return;
      setState(() {
        _lastMotionData = data;
      });
    });
  }

  Future<void> _stopListening() async {
    await _slopeSub?.cancel();
    _slopeSub = null;
    await _gpsInfoSub?.cancel();
    _gpsInfoSub = null;
    await _motionSub?.cancel();
    _motionSub = null;
    await _gpsService.stopListening();

    if (!mounted) return;
    setState(() {
      _isListening = false;
    });
  }

  @override
  void dispose() {
    _slopeSub?.cancel();
    _gpsInfoSub?.cancel();
    _motionSub?.cancel();
    _gpsService.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Slope Detection (Stateful)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // وضعیت Listening
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('وضعیت Listening', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Text('در حال بارگذاری...')
                    else if (_errorMessage != null)
                      Text('خطا: $_errorMessage', style: const TextStyle(color: Colors.red))
                    else
                      Text(_isListening ? 'در حال listening...' : 'Listening متوقف شده'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // دکمه‌های عملیات
            if (!_isLoading && _errorMessage == null) ...[
              _buildActionButton(
                _isListening ? 'توقف Listening' : 'شروع Listening',
                _isListening ? Icons.stop : Icons.play_arrow,
                _isListening ? _stopListening : _startListening,
                color: _isListening ? Colors.red : Colors.green,
              ),
              const SizedBox(height: 8),
              if (_errorMessage != null)
                ElevatedButton(
                  onPressed: _initialize,
                  child: const Text('تلاش مجدد'),
                ),
            ],

            const SizedBox(height: 24),

            // نمایش داده‌ها
            if (_isLoading)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else if (_errorMessage != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('خطا: $_errorMessage'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _initialize,
                        child: const Text('تلاش مجدد'),
                      ),
                    ],
                  ),
                ),
              )
            else if (_lastSlopeData == null)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('در انتظار دریافت داده...'),
                        SizedBox(height: 8),
                        Text(
                          'لطفاً صبر کنید تا GPS و سنسورها فعال شوند',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else ...[
              _buildSlopeDirectionCard(_lastSlopeData!),
              const SizedBox(height: 16),
              _buildSlopeDataCard(_lastSlopeData!),
              const SizedBox(height: 16),
              _buildPositionCard(_lastSlopeData!),
              if (_lastGpsInfo != null) ...[
                const SizedBox(height: 16),
                _buildGPSInfoCard(_lastGpsInfo!),
              ],
              if (_lastMotionData != null) ...[
                const SizedBox(height: 16),
                _buildMotionInfoCard(_lastMotionData!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSlopeDirectionCard(CarSlopeData data) {
    Color color;
    IconData icon;
    String text;

    switch (data.direction) {
      case CarSlopeDirection.uphill:
        color = Colors.orange;
        icon = Icons.trending_up;
        text = 'سربالایی / Uphill';
        break;
      case CarSlopeDirection.downhill:
        color = Colors.blue;
        icon = Icons.trending_down;
        text = 'سرپایینی / Downhill';
        break;
      case CarSlopeDirection.flat:
        color = Colors.green;
        icon = Icons.trending_flat;
        text = 'صاف / Flat';
        break;
      case CarSlopeDirection.unknown:
        color = Colors.grey;
        icon = Icons.help_outline;
        text = 'نامشخص / Unknown';
        break;
    }

    final gradePercent = (data.fusedGrade * 100).toStringAsFixed(1);

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 8),
            Text('شیب: $gradePercent%', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Speed: ${data.speedKmh.toStringAsFixed(1)} km/h', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlopeDataCard(CarSlopeData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('اطلاعات شیب / Slope Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Fused Grade', '${(data.fusedGrade * 100).toStringAsFixed(2)}%'),
            if (data.gpsGrade != null) _buildInfoRow('GPS Grade', '${(data.gpsGrade! * 100).toStringAsFixed(2)}%'),
            if (data.imuPitchDegrees != null) _buildInfoRow('IMU Pitch', '${data.imuPitchDegrees!.toStringAsFixed(2)}°'),
            _buildInfoRow('Speed', '${data.speedKmh.toStringAsFixed(1)} km/h'),
            _buildInfoRow('Direction', data.direction.toString().split('.').last),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionCard(CarSlopeData data) {
    if (data.position == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('موقعیت GPS در دسترس نیست')),
        ),
      );
    }

    final pos = data.position!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('موقعیت GPS / GPS Position', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Latitude', pos.latitude.toStringAsFixed(6)),
            _buildInfoRow('Longitude', pos.longitude.toStringAsFixed(6)),
            _buildInfoRow('Altitude', '${pos.altitude.toStringAsFixed(2)} m'),
            _buildInfoRow('Accuracy', '${pos.accuracy.toStringAsFixed(2)} m'),
            _buildInfoRow('Speed', '${pos.speed.toStringAsFixed(2)} m/s'),
            _buildInfoRow('Heading', '${pos.heading.toStringAsFixed(2)}°'),
          ],
        ),
      ),
    );
  }

  Widget _buildGPSInfoCard(GPSLocationInfo gpsInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('اطلاعات GPS / GPS Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('منبع / Source', gpsInfo.sourceDescription),
            _buildInfoRow('GPS Service', gpsInfo.isLocationServiceEnabled ? 'فعال / Enabled' : 'غیرفعال / Disabled'),
            _buildInfoRow('دقت / Accuracy', '${gpsInfo.accuracyMeters.toStringAsFixed(2)} متر'),
            const SizedBox(height: 8),
            _buildSourceChip(gpsInfo.source),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text('جزئیات موقعیت / Position Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildInfoRow('Latitude', gpsInfo.position.latitude.toStringAsFixed(6)),
            _buildInfoRow('Longitude', gpsInfo.position.longitude.toStringAsFixed(6)),
            _buildInfoRow('Altitude', '${gpsInfo.position.altitude.toStringAsFixed(2)} m'),
            _buildInfoRow('Speed', '${gpsInfo.position.speed.toStringAsFixed(2)} m/s'),
            _buildInfoRow('Heading', '${gpsInfo.position.heading.toStringAsFixed(2)}°'),
            _buildInfoRow('Timestamp', gpsInfo.position.timestamp.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildMotionInfoCard(MotionData motionData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('اطلاعات Motion / Motion Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Slope Direction', motionData.slopeDirection.toString().split('.').last),
            _buildInfoRow('Pitch', '${motionData.pitchDegrees.toStringAsFixed(2)}°'),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            const Text('Accelerometer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildInfoRow('X', motionData.accelerometer.x.toStringAsFixed(3)),
            _buildInfoRow('Y', motionData.accelerometer.y.toStringAsFixed(3)),
            _buildInfoRow('Z', motionData.accelerometer.z.toStringAsFixed(3)),
            if (motionData.gyroscope != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Gyroscope', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildInfoRow('X', motionData.gyroscope!.x.toStringAsFixed(3)),
              _buildInfoRow('Y', motionData.gyroscope!.y.toStringAsFixed(3)),
              _buildInfoRow('Z', motionData.gyroscope!.z.toStringAsFixed(3)),
            ],
            if (motionData.velocityX != null || motionData.velocityY != null || motionData.velocityZ != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const Text('Velocity Changes (m/s³)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildInfoRow('Velocity X', motionData.velocityX?.toStringAsFixed(3) ?? 'N/A'),
              _buildInfoRow('Velocity Y', motionData.velocityY?.toStringAsFixed(3) ?? 'N/A'),
              _buildInfoRow('Velocity Z', motionData.velocityZ?.toStringAsFixed(3) ?? 'N/A'),
            ],
            const SizedBox(height: 8),
            _buildInfoRow('Timestamp', motionData.timestamp.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed, {Color? color}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
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

    return Chip(
      avatar: Icon(icon, color: color, size: 20),
      label: Text(
        source.toString().split('.').last.toUpperCase(),
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}

