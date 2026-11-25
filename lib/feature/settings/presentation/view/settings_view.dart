import 'package:flutter/material.dart';
import 'package:elrasheedy_dashboard/feature/settings/presentation/widgets/settings_view_body.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return
      const SingleChildScrollView(
        child: SettingsViewBody(),

      );
  }
}