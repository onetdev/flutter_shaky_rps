import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ShakeGameSet {
  const ShakeGameSet(this.name, this.items, this.icon);

  final String name;
  final List<ShakeResult> items;
  final ShakeResult icon;
}

class ShakeGameSets {
  static ShakeGameSet classic = ShakeGameSet(
      'classic',
      [
        ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeResult(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeResult(icon: FontAwesomeIcons.handScissors, text: 'Scissors')
      ],
      ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Classic mode'));

  static ShakeGameSet spock = ShakeGameSet(
      'spock',
      [
        ShakeResult(icon: FontAwesomeIcons.handRock, text: 'Rock'),
        ShakeResult(icon: FontAwesomeIcons.handPaper, text: 'Paper'),
        ShakeResult(icon: FontAwesomeIcons.handScissors, text: 'Scissors'),
        ShakeResult(icon: FontAwesomeIcons.handSpock, text: 'Spock'),
        ShakeResult(icon: FontAwesomeIcons.handLizard, text: 'Lizard')
      ],
      ShakeResult(
          icon: FontAwesomeIcons.handSpock, text: 'Spock and Lizad mode'));

  static ShakeGameSet dice = ShakeGameSet(
      'dice',
      [
        ShakeResult(icon: FontAwesomeIcons.diceOne, text: 'One'),
        ShakeResult(icon: FontAwesomeIcons.diceTwo, text: 'Two'),
        ShakeResult(icon: FontAwesomeIcons.diceThree, text: 'Three'),
        ShakeResult(icon: FontAwesomeIcons.diceFour, text: 'Four'),
        ShakeResult(icon: FontAwesomeIcons.diceFive, text: 'Five'),
        ShakeResult(icon: FontAwesomeIcons.diceSix, text: 'Six'),
      ],
      ShakeResult(icon: FontAwesomeIcons.diceSix, text: 'Dice mode'));

  static Map<String, ShakeGameSet> getModes() {
    var result = Map<String, ShakeGameSet>();
    result['classic'] = classic;
    result['spock'] = spock;
    result['dice'] = dice;

    return result;
  }
}

class ShakeResult {
  ShakeResult({this.icon, this.text});

  final IconData icon;
  final String text;
}