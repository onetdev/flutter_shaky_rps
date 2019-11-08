import 'package:flutter/material.dart';
import 'package:shakey_rps/ui/widget/shake_randomizer.dart';

typedef SourceOnChangedCallback = Function(ShakeResultMode mode);

class SourceSelector extends StatelessWidget {
  @override
  SourceSelector({Key key, this.onChanged, this.mode}) : super(key: key);

  final SourceOnChangedCallback onChanged;
  final ShakeResultMode mode;

  @override
  Widget build(BuildContext context) {
    var icons = List<Widget>();
    ShakeResultModes.getModes().forEach((name, elem) {
      icons.add(_buildIcon(elem));
    });

    return Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: icons));
  }

  Widget _buildIcon(ShakeResultMode mode) {
    return GestureDetector(
        onTap: () => onChanged(mode),
        child: Icon(
          mode.icon.icon,
          color: mode.name == this.mode.name
              ? Colors.white
              : const Color(0xfff43960),
          size: 40.0,
          semanticLabel: mode.icon.text,
        ));
  }
}
