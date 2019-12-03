import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:shaky_rps/lang.dart';
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
        elevation: 5,
        title: Text(Lang.of(context).translate('info.title')),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
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
        child: _buildListView(context),
      ),
    );
  }

  ListView _buildListView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var t = (key) => Lang.of(context).translate(key);

    return ListView(
      padding: EdgeInsets.only(
          left: 20, right: math.max(size.width - 400, 20), bottom: 15),
      children: [
        SizedBox(height: 15),
        Text("${t('info.disclaimer.title')}", style: headline),
        Text(
            "\n${t('info.disclaimer.hold_tight')}\n\n" +
                "${t('info.disclaimer.experience_differ')}\n",
            style: paragraph),
        Text(t("info.how_to_play.title"), style: headline),
        Text(
            "\n${t('info.how_to_play.step_1')}\n\n" +
                "${t('info.how_to_play.step_2')}\n",
            style: paragraph),
        Text(t('info.outcomes.title'), style: headline),
        SizedBox(height: 10),
        Text("${t('info.outcomes.body')}\n", style: paragraph),
        _buildRollTable(context),
        SizedBox(height: 10),
        Text(t('info.about.title'), style: headline),
        Text(
          "\n${t('info.about.body')}\n\n${t('info.about.contact')}\n",
          style: paragraph,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => _launchUrl(privacyUrl),
              child: Text(
                t('info.privacy_policy'),
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
    );
  }

  /// Generates a table with all the possible options for different rolling
  /// modes.
  Column _buildRollTable(BuildContext context) {
    var rows = List<Widget>();
    var t = (key) => Lang.of(context).translate(key);

    ShakeGameSets.getModes().forEach((name, mode) {
      rows.add(Text(
        t(mode.icon.text),
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

  /// Delegate for opening email address and https pages
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
