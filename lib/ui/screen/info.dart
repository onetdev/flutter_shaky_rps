import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  @override
  _Info createState() => _Info();
}

class _Info extends State<Info> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;

    var headline = TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );

    var paragraph = TextStyle(color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff27364e),
        elevation: 0,
        actions: [
          Container(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Icon(FontAwesomeIcons.solidEnvelope),
              onPressed: () => _sendEmail(),
            ),
          )
        ],
      ),
      body: Container(
        color: const Color(0xff27364e),
        width: deviceSize.width,
        height: deviceSize.height,
        child: ListView(padding:  EdgeInsets.symmetric(horizontal: 15), children: [
          Text('Disclaimer!', style: headline),
          Text(
              "\nAlways hold your device tightly when shaking because if you drop it I'm are not responsible.\n",
              style: paragraph),
          Text('How to play', style: headline),
          Text(
              "\n1.) Choose your preferred game mode from the bottom (classic, lizard-spock, dice) of the screen.\n",
              style: paragraph),
          Text(
              "2.) Shake the phone and the result will be on your screen as soon as you stop shaking your phone.\n",
              style: paragraph),
          Text('About', style: headline),
          Text(
            "\nI'm a Hungarian developer who loves Flutter and this was one of my experiments that ended up in the store. I hope you like it.\n" +
                "\nIf you have any question, tap on the envelop in the right top corner.",
            style: paragraph,
          ),
          Text(
              "\nPs: We don't collect any data about you also no ads for this time. Yet.\n",
              style: paragraph),
        ]),
      ),
    );
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
}
