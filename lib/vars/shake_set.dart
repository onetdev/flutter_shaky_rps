import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShakeItemSet {
  const ShakeItemSet(this.name, this.items, this.icon);

  final String name;
  final List<ShakeItem> items;
  final ShakeItem icon;
}

class ShakeGameSets {
  static ShakeItemSet classic = ShakeItemSet(
      'classic',
      [
        ShakeItem(icon: FontAwesomeIcons.handRock, text: 'modes.classic.rock'),
        ShakeItem(icon: FontAwesomeIcons.handPaper, text: 'modes.classic.paper'),
        ShakeItem(icon: FontAwesomeIcons.handScissors, text: 'modes.classic.scissors')
      ],
      ShakeItem(icon: FontAwesomeIcons.handRock, text: 'modes.classic.title'));

  static ShakeItemSet spock = ShakeItemSet(
      'spock',
      [
        ShakeItem(icon: FontAwesomeIcons.handRock, text: 'modes.classic.rock'),
        ShakeItem(icon: FontAwesomeIcons.handPaper, text: 'modes.classic.paper'),
        ShakeItem(icon: FontAwesomeIcons.handScissors, text: 'modes.classic.scissors'),
        ShakeItem(icon: FontAwesomeIcons.handSpock, text: 'modes.spock.spock'),
        ShakeItem(icon: FontAwesomeIcons.handLizard, text: 'modes.spock.lizard')
      ],
      ShakeItem(
          icon: FontAwesomeIcons.handSpock, text: 'modes.spock.title'));

  static ShakeItemSet dice = ShakeItemSet(
      'dice',
      [
        ShakeItem(icon: FontAwesomeIcons.diceOne, text: 'modes.dice.one'),
        ShakeItem(icon: FontAwesomeIcons.diceTwo, text: 'modes.dice.two'),
        ShakeItem(icon: FontAwesomeIcons.diceThree, text: 'modes.dice.three'),
        ShakeItem(icon: FontAwesomeIcons.diceFour, text: 'modes.dice.four'),
        ShakeItem(icon: FontAwesomeIcons.diceFive, text: 'modes.dice.five'),
        ShakeItem(icon: FontAwesomeIcons.diceSix, text: 'modes.dice.six'),
      ],
      ShakeItem(icon: FontAwesomeIcons.diceSix, text: 'modes.dice.title'));

  static ShakeItemSet particles = ShakeItemSet(
    'particles',
    [
      ShakeItem(icon: FontAwesomeIcons.asterisk, text: 'Asteriks'),
      ShakeItem(icon: FontAwesomeIcons.meteor, text: 'Meteor'),
      ShakeItem(icon: FontAwesomeIcons.bomb, text: 'Bomb'),
      ShakeItem(icon: FontAwesomeIcons.cog, text: 'Cog'),
      ShakeItem(icon: FontAwesomeIcons.fire, text: 'Fire'),
      ShakeItem(icon: FontAwesomeIcons.snowflake, text: 'Snowflake'),
    ],
    ShakeItem(icon: FontAwesomeIcons.asterisk, text: 'Asteriks'),
  );

  static Map<String, ShakeItemSet> getModes() {
    var result = Map<String, ShakeItemSet>();
    result['classic'] = classic;
    result['spock'] = spock;
    result['dice'] = dice;

    return result;
  }
}

class ShakeItem {
  ShakeItem({this.icon, this.text});

  final IconData icon;
  final String text;
}

class ShakeParticle {
  ShakeParticle(this.item, this.seed);

  final ShakeItem item;
  final double seed;
}