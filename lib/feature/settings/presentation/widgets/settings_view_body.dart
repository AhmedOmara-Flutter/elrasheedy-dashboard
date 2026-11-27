import 'package:elrasheedy_dashboard/feature/settings/presentation/widgets/settings_desktop_layout.dart';
import 'package:elrasheedy_dashboard/feature/settings/presentation/widgets/settings_mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/extension/responsive_extension.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  String version = "0.0.0";

  @override
  void initState() {
    super.initState();
    _getVersion();
  }

  Future<void> _getVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      version = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: context.isDesktop
              ? SettingsDesktopLayout()
              : SettingsMobileLayout(),

    );
  }
}