import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shaky_rps/ui/widget/shake_randomizer.dart';
import 'package:shaky_rps/ui/widget/source_selector.dart';
import 'package:url_launcher/url_launcher.dart';

class Game extends StatefulWidget {
  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  ShakeResultMode _mode = ShakeResultModes.classic;

  static const Text helpTitle = Text("About & how to play");
  static const Text helpContent = Text(
      "Most importantly: Hold your device tightly because if you drop it we are not responsible.\n\n" +
          "Just shake the phone and the result will be on your screen.\n" +
          "To change the game mode, select one of the options from the bottom of the app.\n\n" +
          "Ps: We don't collect any data about you also no ads for this time. Yet.");

  onModeChange(ShakeResultMode mode) {
    setState(() {
      _mode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(backgroundColor: Color(0xff27364e), elevation: 0, actions: [
          Container(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.info),
                onPressed: () => onHelp(),
              ))
        ]),
        body: Container(
          color: const Color(0xff27364e),
          child: ShakeRandomizer(_mode),
        ),
        bottomNavigationBar: _buildBottom());
  }

  Widget _buildBottom() {
    return BottomAppBar(
        elevation: 0,
        child: Container(
            //color: const Color(0xff27364e),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xff27364e), const Color(0xff1f2b3e)],
            )),
            child: SourceSelector(
              mode: _mode,
              onChanged: (mode) => onModeChange(mode),
            )));
  }

  void onHelp() {
    if (Platform.isAndroid) _showMaterialDialog();
    if (Platform.isIOS) _showCupertinoDialog();
  }

  void _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: helpTitle,
            content: helpContent,
            actions: <Widget>[
              FlatButton(
                onPressed: () => _dismissDialog(),
                child: Text('Close'),
              ),
              FlatButton(
                onPressed: () {
                  _sendEmail();
                },
                child: Text('Contact'),
              )
            ],
          );
        });
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: helpTitle,
            content: helpContent,
            actions: <Widget>[
              FlatButton(
                onPressed: () => _dismissDialog(),
                child: Text('Close'),
              ),
              FlatButton(
                onPressed: () => _sendEmail(),
                child: Text('Contact'),
              )
            ],
          );
        });
  }

  void _sendEmail() async {
    const url = 'mailto:József Koller<contact@onetdev.com>';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }
}
