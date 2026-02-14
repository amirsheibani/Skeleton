import 'dart:async';

import 'package:flutter/material.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:skeleton/core/di/base/di_setup.dart';

class MotionInfoPage extends StatefulWidget {
  const MotionInfoPage({super.key});

  @override
  State<MotionInfoPage> createState() => _MotionInfoPageState();
}

class _MotionInfoPageState extends State<MotionInfoPage> {
  late final MotionService _motionService;
  StreamSubscription<MotionData>? _motionSub;
  MotionData? _lastMotionData;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _motionService = getIt<MotionService>();
    _isListening = _motionService.isListening;

    // Listen to motion stream
    _motionSub = _motionService.motionStream.listen((data) {
      setState(() {
        _lastMotionData = data;
        _isListening = _motionService.isListening;
      });
    });
  }

  @override
  void dispose() {
    _motionSub?.cancel();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _motionService.stop();
    } else {
      _motionService.start();
    }
    setState(() {
      _isListening = _motionService.isListening;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Motion Service Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Motion Status',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Listening:'),
                        Text(_isListening ? 'ON' : 'OFF'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Slope:'),
                        Text(_lastMotionData?.slopeDirection.toString().split('.').last ?? '-'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pitch (deg):'),
                        Text(
                          _lastMotionData != null
                              ? _lastMotionData!.pitchDegrees.toStringAsFixed(1)
                              : '-',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _toggleListening,
              icon: Icon(_isListening ? Icons.stop : Icons.play_arrow),
              label: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            if (_lastMotionData != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sensor Data',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        'Accelerometer X',
                        _lastMotionData!.accelerometer.x.toStringAsFixed(3),
                      ),
                      _buildInfoRow(
                        'Accelerometer Y',
                        _lastMotionData!.accelerometer.y.toStringAsFixed(3),
                      ),
                      _buildInfoRow(
                        'Accelerometer Z',
                        _lastMotionData!.accelerometer.z.toStringAsFixed(3),
                      ),
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      const Text(
                        'Velocity Changes (m/s³)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Velocity X',
                        _lastMotionData!.velocityX != null
                            ? _lastMotionData!.velocityX!.toStringAsFixed(3)
                            : 'N/A',
                      ),
                      _buildInfoRow(
                        'Velocity Y',
                        _lastMotionData!.velocityY != null
                            ? _lastMotionData!.velocityY!.toStringAsFixed(3)
                            : 'N/A',
                      ),
                      _buildInfoRow(
                        'Velocity Z',
                        _lastMotionData!.velocityZ != null
                            ? _lastMotionData!.velocityZ!.toStringAsFixed(3)
                            : 'N/A',
                      ),
                      if (_lastMotionData!.gyroscope != null) ...[
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          'Gyroscope X',
                          _lastMotionData!.gyroscope!.x.toStringAsFixed(3),
                        ),
                        _buildInfoRow(
                          'Gyroscope Y',
                          _lastMotionData!.gyroscope!.y.toStringAsFixed(3),
                        ),
                        _buildInfoRow(
                          'Gyroscope Z',
                          _lastMotionData!.gyroscope!.z.toStringAsFixed(3),
                        ),
                      ],
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        'Timestamp',
                        _lastMotionData!.timestamp.toIso8601String(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
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
}
