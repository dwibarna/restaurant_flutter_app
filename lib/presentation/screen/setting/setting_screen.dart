import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_flutter_app/provider/setting_provider.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
    SettingProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: _buildProviderSettingList(),
    );
  }

  ChangeNotifierProvider<SettingProvider> _buildProviderSettingList() {
    return ChangeNotifierProvider(
      create: (_) => SettingProvider(),
      child: Consumer<SettingProvider>(
        builder: (context, state, _) {
          state.getStateNotify();
          return buildSettingsList(state.stateNotify, context);
        },
      ),
    );
  }

  SettingsList buildSettingsList(bool state, BuildContext context) {
    return SettingsList(sections: [
      SettingsSection(title: const Text(""), tiles: <SettingsTile>[
        SettingsTile.switchTile(
          initialValue: state,
          onToggle: (value) {
            context.read<SettingProvider>().setStateNotify(value);
            context.read<SettingProvider>().scheduledNotification(value);
          },
          title: const Text("Schedule Alarm"),
        )
      ])
    ]);
  }
}
