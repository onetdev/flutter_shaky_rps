import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';
import 'package:shaky_rps/controllers/shaker.dart';
import 'package:shaky_rps/ui/widget/shake_randomizer.dart';
import 'package:shaky_rps/ui/widget/source_selector.dart';
import 'package:url_launcher/url_launcher.dart';

class Game extends StatefulWidget {
  @override
  _Game createState() => _Game();
}

class _Game extends State<Game> {
  ShakeGameSet _gameSet = ShakeGameSets.classic;
  Shaker _shaker;

  static const Text helpTitle = Text("About & how to play");
  static const Text helpContent = Text(
      "Most importantly: Hold your device tightly because if you drop it we are not responsible.\n\n" +
          "Just shake the phone and the result will be on your screen.\n" +
          "To change the game mode, select one of the options from the bottom of the app.\n\n" +
          "Ps: We don't collect any data about you also no ads for this time. Yet.");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    _shaker = Provider.of<Shaker>(context);
    _shaker.removeListener(onShakerStateChange);
    _shaker.addListener(onShakerStateChange);

    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff27364e),
          elevation: 0,
          actions: [
            Container(
              padding: EdgeInsets.only(right: 20),
              child: IconButton(
                icon: Icon(FontAwesomeIcons.info),
                onPressed: () => showHelp(),
              ),
            )
          ],
        ),
        body: Container(
            color: const Color(0xff27364e),
            width: deviceSize.width,
            child: ShakeRandomizer(_gameSet)),
        bottomNavigationBar: _buildBottom(),
      ),
      _shaker?.status != ShakeStatus.active
          ? Container()
          : _buildFlashingOverlay(deviceSize),
    ]);
  }

  void onShakerStateChange() {
    setState(() {
      /// This will schedule a redraw
    });
  }

  /// This overlay will be shown if the phone is shaking.
  /// Otherwise should not be applied to the widget tree.
  Widget _buildFlashingOverlay(Size size) {
    return Container(
      color: RandomColor().randomColor(
          colorSaturation: ColorSaturation.highSaturation,
          colorBrightness: ColorBrightness.light
          // colorHue: ColorHue.multiple(colorHues: [ColorHue.red, ColorHue.blue]),
          ),
      child: SizedBox(width: size.width, height: size.height),
    );
  }

  /// Bottom part contains the available game sets.
  /// When game set is changed the corresponding button will be highlighted.
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
          ),
        ),
        child: SourceSelector(
          mode: _gameSet,
          onChanged: (mode) => onGameSetChange(mode),
        ),
      ),
    );
  }

  /// Event handler for the game set selector.0000
  onGameSetChange(ShakeGameSet mode) {
    setState(() {
      _gameSet = mode;
    });
  }

  /// Opens the help modal for a specific platform.
  /// Only iOS and Android is supported at the moment and nothing will happen
  /// for unknown platforms.
  void showHelp() {
    if (Platform.isAndroid) _showMaterialDialog();
    if (Platform.isIOS) _showCupertinoDialog();
  }

  /// iOS specific modal display, has identical text as the android one.
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

  /// Android specific modal display, has identical text as the iOS one.
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

  /// Tries to open the OS's default mailer to send email to the owner of the app.
  void _sendEmail() async {
    const url = 'mailto:József Koller<contact@onetdev.com>';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Hides the dialog on all platforms.
  void _dismissDialog() {
    Navigator.pop(context);
  }
}
