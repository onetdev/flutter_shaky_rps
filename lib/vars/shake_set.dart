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
        ShakeItem(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeItem(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeItem(icon: FontAwesomeIcons.handScissors, text: 'Scissors')
      ],
      ShakeItem(icon: FontAwesomeIcons.handRock, text: 'Classic mode'));

  static ShakeItemSet spock = ShakeItemSet(
      'spock',
      [
        ShakeItem(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeItem(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeItem(icon: FontAwesomeIcons.handScissors, text: 'Scissors'),
        ShakeItem(icon: FontAwesomeIcons.handSpock, text: 'Spock'),
        ShakeItem(icon: FontAwesomeIcons.handLizard, text: 'Lizard')
      ],
      ShakeItem(
          icon: FontAwesomeIcons.handSpock, text: 'Spock and Lizad mode'));

  static ShakeItemSet dice = ShakeItemSet(
      'dice',
      [
        ShakeItem(icon: FontAwesomeIcons.diceOne, text: 'One'),
        ShakeItem(icon: FontAwesomeIcons.diceTwo, text: 'Two'),
        ShakeItem(icon: FontAwesomeIcons.diceThree, text: 'Three'),
        ShakeItem(icon: FontAwesomeIcons.diceFour, text: 'Four'),
        ShakeItem(icon: FontAwesomeIcons.diceFive, text: 'Five'),
        ShakeItem(icon: FontAwesomeIcons.diceSix, text: 'Six'),
      ],
      ShakeItem(icon: FontAwesomeIcons.diceSix, text: 'Dice mode'));

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