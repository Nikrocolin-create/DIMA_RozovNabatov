import 'package:cleanair_layout/Screens/Favorites/main_favorite.dart';
import 'package:cleanair_layout/Screens/Map/map_main.dart';
import 'package:cleanair_layout/Screens/Profile/add_elements/iconbutton.dart';
import 'package:cleanair_layout/Screens/Profile/add_elements/inside_widgets/customdialoglogin.dart';
import 'package:cleanair_layout/Screens/Profile/add_elements/inside_widgets/help.dart';
import 'package:cleanair_layout/constants.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class IconContainerMenu extends StatelessWidget {

  final double iconSize = 36.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.3,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButtonContainer(
                iconObject: Icon(Icons.map, color: Colors.blue, size: this.iconSize),
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MainMap();
                      }
                    )
                  );
                },
                size: size.width / 3.33,
                text: "Map",
              ),
              IconButtonContainer(
                iconObject: Icon(Icons.calendar_today, color: Colors.blueAccent, size: this.iconSize,),
                press: () {
                
                },
                text: "Calendar",
                size: size.width / 3.33,
              ),
              IconButtonContainer(
                iconObject: Icon(Icons.favorite_outline, color: Colors.red, size: this.iconSize,),
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return MainFavorite();
                      }
                    ),
                  );
                },
                text: "Favorites",
                size: size.width / 3.33,
              ),
            ],
          ),
          Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButtonContainer(
                iconObject: Icon (Icons.settings, color: Colors.blueGrey, size: this.iconSize,), 
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return Settings();
                    })
                  );
                },
                text: "Setting",
                size: size.width / 3.33,
              ),
              IconButtonContainer(
                iconObject: Icon (Icons.help, color: Colors.lightBlue, size: this.iconSize,), 
                press: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return HelpIcon();
                    })
                  );
                },
                text: "Help",
                size: size.width / 3.33,
              ),
              IconButtonContainer(
                iconObject: Icon (Icons.person, size: this.iconSize,), 
                press: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogLogin();
                    }
                  );
                },
                text: "Login",
                size: size.width / 3.33,
              ),
            ]
          )
        ]
      ),
    );
  }
}

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