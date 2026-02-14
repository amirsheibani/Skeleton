import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:framework_base/packages/framework_handler/lib/handler_framework.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/manager/gps_provider.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/manager/gps_state.dart';

class GPSInfoPage extends ConsumerStatefulWidget {
  const GPSInfoPage({super.key});

  @override
  ConsumerState<GPSInfoPage> createState() => _GPSInfoPageState();
}

class _GPSInfoPageState extends ConsumerState<GPSInfoPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(gpsProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gpsState = ref.watch(gpsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('GPS Service Example')),
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
                    switch (gpsState) {

                      GPSSuccess(:final gpsPermissionStatus) => Text('$gpsPermissionStatus'),
                      GPSLoading() => Text('loading...'),
                      GPSState() => SizedBox(),
                    },
                    const SizedBox(height: 8),
                    switch (gpsState) {
                      GPSSuccess() => _buildPermissionStatusChip(gpsState.gpsPermissionStatus),
                      GPSState() => SizedBox(),
                    },
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // دکمه‌های عملیات
            ...switch (gpsState) {
              GPSSuccess() => [
                _buildActionButton(
                  'گرفتن موقعیت فعلی',
                  Icons.my_location,
                  () {
                    ref.read(gpsProvider.notifier).getCurrentPosition();
                  },
                  color: Colors.green,
                  enabled: gpsState.gpsPermissionStatus == GPSPermissionStatus.granted && gpsState.isListening == false,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  'گرفتن آخرین موقعیت',
                  Icons.location_searching,
                  () {
                    ref.read(gpsProvider.notifier).getLastKnownPosition();
                  },
                  color: Colors.orange,
                  enabled: gpsState.gpsPermissionStatus == GPSPermissionStatus.granted && gpsState.isListening == false,
                ),
                const SizedBox(height: 8),
                _buildActionButton(
                  (gpsState.isListening ?? false) ? 'توقف Listening' : 'شروع Listening',
                  (gpsState.isListening ?? false) ? Icons.stop : Icons.play_arrow,
                  !(gpsState.isListening ?? false) ? () {
                    ref.read(gpsProvider.notifier).listenChange();
                  } : (){
                    ref.read(gpsProvider.notifier).stopListen();
                  },
                  color: (gpsState.isListening ?? false) ? Colors.red : Colors.purple,
                  enabled: gpsState.gpsPermissionStatus == GPSPermissionStatus.granted,
                ),
              ],
              GPSState() => [SizedBox()],
            },

            // const SizedBox(height: 8),
            // _buildActionButton('باز کردن تنظیمات', Icons.settings, _openSettings, color: Colors.grey),
            const SizedBox(height: 24),

            ...switch (gpsState) {
              GPSSuccess() => [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('موقعیت فعلی', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildInfoRow('Latitude', gpsState.position?.latitude.toStringAsFixed(6) ?? '-'),
                        _buildInfoRow('Longitude', gpsState.position?.longitude.toStringAsFixed(6) ?? '-'),
                        _buildInfoRow('Accuracy', '${gpsState.position?.accuracy.toStringAsFixed(2)  ?? '-' } متر'),
                        _buildInfoRow('Altitude', '${gpsState.position?.altitude.toStringAsFixed(2)  ?? '-' } متر'),
                        _buildInfoRow('Speed', '${gpsState.position?.speed.toStringAsFixed(2)  ?? '-' } m/s'),
                        _buildInfoRow('Heading', '${gpsState.position?.heading.toStringAsFixed(2) ?? '-' } °'),
                        _buildInfoRow('Timestamp', gpsState.position?.timestamp.toString() ?? '-'),
                      ],
                    ),
                  ),
                ),
                if (gpsState.locationInfo != null) ...[
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
                            gpsState.locationInfo!.sourceDescription,
                          ),
                          _buildInfoRow(
                            'GPS Service',
                            gpsState.locationInfo!.isLocationServiceEnabled ? 'فعال / Enabled' : 'غیرفعال / Disabled',
                          ),
                          _buildInfoRow(
                            'دقت / Accuracy',
                            '${gpsState.locationInfo!.accuracyMeters.toStringAsFixed(2)} متر',
                          ),
                          _buildSourceChip(gpsState.locationInfo!.source),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
              GPSState() => [SizedBox()],
            },
            // نمایش موقعیت

          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStatusChip(GPSPermissionStatus? permissionStatus) {
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
      case null:
        color = Colors.grey;
        text = 'null';
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
      style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16)),
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
