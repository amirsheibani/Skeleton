import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/main_layout/presentation/features/car_slope_info/presentation/pages/car_slope_page.dart';
import 'package:skeleton/features/main_layout/presentation/features/gps_info/presentation/pages/gps_info_page.dart';
import 'package:skeleton/features/main_layout/presentation/features/home/presentation/pages/home_page.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/presentation/pages/my_ip.dart';
import 'package:skeleton/features/main_layout/presentation/features/profile/presentation/pages/profile_page.dart';
import 'package:skeleton/features/main_layout/presentation/manager/main_layout_provider.dart';
import 'package:skeleton/generated/l10n.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  final List<BottomNavigationBarItem> bottomNavigationBarItem = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: S.current.bottom_navigation_bar_home),
    BottomNavigationBarItem(icon: Icon(Icons.wifi), label: S.current.bottom_navigation_bar_my_ip),
    BottomNavigationBarItem(icon: Icon(Icons.car_repair), label: S.current.bottom_navigation_bar_car_slope),
    BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: S.current.bottom_navigation_bar_gps_info),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: S.current.bottom_navigation_bar_profile),
  ];

  final List<Widget> bodyItem = [HomePage(), MyIpPage(), CarSlopePage(), GPSInfoPage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(mainLayoutProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainLayoutState = ref.watch(mainLayoutProvider);
    return Scaffold(
      body: bodyItem[mainLayoutState],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: mainLayoutState,
        items: bottomNavigationBarItem,
        onTap: (index) {
          ref.read(mainLayoutProvider.notifier).goto(index);
        },
      ),
    );
  }
}
