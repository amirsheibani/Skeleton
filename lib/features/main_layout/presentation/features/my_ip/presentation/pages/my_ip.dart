import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/presentation/manager/my_ip_provider.dart';
import 'package:skeleton/features/main_layout/presentation/features/my_ip/presentation/manager/my_ip_state.dart';

class MyIpPage extends ConsumerStatefulWidget {
  const MyIpPage({super.key});

  @override
  ConsumerState<MyIpPage> createState() => _MyIpPageState();
}

class _MyIpPageState extends ConsumerState<MyIpPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(myIpProvider.notifier).getMyIpAddress());
  }

  @override
  Widget build(BuildContext context) {

    final myIpState = ref.watch(myIpProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: switch (myIpState) {
          MyIpInit() => const SizedBox(),
          MyIpLoading() => const CircularProgressIndicator(),
          MyIpSuccess(:final data) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectableText(
                  data?.ip ?? '-',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  data?.country ?? '-',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(
                  data?.cc ?? '-',
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
          MyIpFailed(:final message) => Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
              textAlign: TextAlign.center,
            ),
          _ => const SizedBox(),
        },
      ),
    );
  }
}
