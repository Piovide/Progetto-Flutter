import 'package:flutter/material.dart';
import 'package:wiki_appunti/constants/colors.dart';

class SettingsMenuComponent extends StatefulWidget {
  
  const SettingsMenuComponent({
    super.key,
    required this.title,
    required this.icon,
  });
  
  final String title;
  final IconData icon;

  @override
  _SettingsMenuComponentState createState() => _SettingsMenuComponentState();
}

class _SettingsMenuComponentState extends State<SettingsMenuComponent> {

  bool _enabled = false;

  @override
  Widget build(BuildContext context) {

    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100)
      ),
      selected: _enabled,
      //pressing the ListTile
      onTap: (){
        setState(() {
          _enabled = !_enabled;
        });
      },
      leading: Icon(widget.icon),
      title: Text(widget.title, style: TextStyle(color: black)),
      trailing: Switch(
        //pressing the switch
        onChanged: (bool? value){
          setState(() {
            _enabled = value!;
          });
        },
        value: _enabled,
      ),
    );
  }
}