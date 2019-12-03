import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:shaky_rps/vars/shake_set.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  @override
  _Info createState() => _Info();
}

class _Info extends State<Info> {
  static var headline = TextStyle(
    color: const Color(0xfff23861),
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  static var paragraph = TextStyle(color: Colors.white);
  static String email = "mailto:József Koller<contact@onetdev.com>";
  static String privacyUrl =
      "https://onetdev.com/projects/shaky_rps/privacy_policy.html";

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1f2b3e),
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.solidEnvelope),
              onPressed: () => _launchUrl(email),
            ),
          )
        ],
      ),
      body: Container(
        color: const Color(0xff1f2b3e),
        width: deviceSize.width,
        height: deviceSize.height,
        child: ListView(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 15),
          children: [
            Text('Disclaimer', style: headline),
            Text(
                "\nAlways hold your device tightly when shaking because if you drop it I'm are not responsible.\n",
                style: paragraph),
            Text(
                "The user experience might differ on per phone basis.\n",
                style: paragraph),
            Text('How to play', style: headline),
            Text(
                "\n1.) Choose your preferred game mode from the bottom (classic, lizard-spock, dice) of the screen.\n",
                style: paragraph),
            Text(
                "2.) Shake the phone and the result will be on your screen as soon as you stop shaking your phone.\n",
                style: paragraph),
            Text("Possible outcomes", style: headline),
            SizedBox(height: 10),
            Text(
                "Based on the game mode you select, the following possible values can be drawn respectively.\n",
                style: paragraph),
            _getRollTable(),
            SizedBox(height: 10),
            Text("Who did this?", style: headline),
            Text(
              "\nI'm a Hungarian \ud83c\udded\ud83c\uddfa developer who loves Flutter and this was one of my experiments that I wanted to share. " +
                  "So, here it goes.\n" +
                  "\nIf you have any question, tap on the envelop in the right top corner.\n",
              style: paragraph,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _launchUrl(privacyUrl),
                  child: Text(
                    "Privacy policy",
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                FutureBuilder(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, info) {
                    if (info.data == null) {
                      return Text('');
                    }
                    return Text(
                      'v${info.data.version} build ${info.data.buildNumber}',
                      style: TextStyle(color: Colors.white30),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column _getRollTable() {
    var rows = List<Widget>();

    ShakeGameSets.getModes().forEach((name, mode) {
      rows.add(Text(
        mode.icon.text,
        style: TextStyle(
          color: const Color(0xfff23861),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ));

      var cols = List<Widget>();
      mode.items.forEach((elem) {
        cols.add(Padding(
          padding: EdgeInsets.only(top: 7, bottom: 20, right: 10),
          child: Icon(elem.icon, color: Colors.white),
        ));
      });

      rows.add(Row(children: cols));
    });

    return Column(
      children: rows,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
