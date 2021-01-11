
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 1.2,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SettingsList(
        backgroundColor: Colors.white10,
        sections: [
          SettingsSection(
            titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            title: 'Common',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Color',
                subtitle: 'White Theme',
                leading: Icon(Icons.colorize),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: 'Watch companion',
                onToggle: (bool value) {},
                switchValue: false,
                leading: Icon(Icons.watch),
              )
            ]
          ),
          SettingsSection(
            titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            title: 'Security',
            tiles: [
              SettingsTile.switchTile(
                title: 'Lock app in background', 
                onToggle: (bool value) {}, 
                switchValue: false,
                leading: Icon(Icons.phonelink_lock),
              ),
              SettingsTile.switchTile(
                title: 'Use fingerprint',
                leading: Icon(Icons.fingerprint),
                switchValue: false,
                onToggle: (bool value) {},
              ),
            ]
          ),
          SettingsSection(
            titlePadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            title: 'Misc',
            tiles: [
              SettingsTile(
                title: 'Terms of Service',
                leading: Icon(Icons.description),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Open source licences',
                leading: Icon(Icons.sticky_note_2),
                onPressed: (BuildContext context) {},
              ),
            ]
          )

        ]
      )
    );
  }
}