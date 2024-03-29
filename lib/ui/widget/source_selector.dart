import 'package:flutter/material.dart';
import 'package:shaky_rps/lang.dart';
import 'package:shaky_rps/vars/shake_set.dart';

typedef SourceOnChangedCallback = Function(ShakeItemSet mode);

class SourceSelector extends StatelessWidget {
  @override
  SourceSelector({Key key, this.onChanged, this.mode}) : super(key: key);

  final SourceOnChangedCallback onChanged;
  final ShakeItemSet mode;

  @override
  Widget build(BuildContext context) {
    var icons = List<Widget>();
    int _index = 0;
    var modes = ShakeGameSets.getModes();

    modes.forEach((name, elem) {
      int _position = _index == 0 ? -1 : (_index == modes.length - 1 ? 1 : 0);
      icons.add(_buildItem(context, elem, _position));
      _index++;
    });

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: icons,
      ),
    );
  }

  /// Mode contains all the metadata for a given randomized mode
  /// Position is a value between [-1...1), -1 means first on the left,
  /// 0 means in the middle somewhere and 1 means on the right.
  Widget _buildItem(BuildContext context, ShakeItemSet mode, int position) {
    Color color;
    Color textColor;
    BorderRadius radius;

    /// Selected element coloring.
    if (this.mode.name == mode.name) {
      color = const Color(0xfff23861);
      textColor = Colors.white;
    } else {
      color = const Color(0xaaf23861);
      textColor = const Color(0x66fffffff);
    }

    if (position == -1) {
      radius = new BorderRadius.horizontal(left: Radius.circular(12.0));
    } else if (position == 1) {
      radius = new BorderRadius.horizontal(right: Radius.circular(12.0));
    } else {
      radius = new BorderRadius.circular(0.0);
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 43, horizontal: 0),
      child: RaisedButton(
        onPressed: () => onChanged(mode),
        color: color,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 15),
        shape: RoundedRectangleBorder(borderRadius: radius),
        child: Icon(
          mode.icon.icon,
          color: textColor,
          size: 30.0,
          semanticLabel: Lang.of(context).translate(mode.icon.text),
        ),
      ),
    );
  }
}
