import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class MyCheckBox extends StatefulWidget {
  bool isChecked;

  final String text;

  final ValueChanged<bool> onChanged;

  final TextStyle textStyle;

  MyCheckBox({this.isChecked, this.text, this.onChanged, this.textStyle});

  @override
  _MyCheckBoxState createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isChecked = !widget.isChecked;
          widget.onChanged(widget.isChecked);
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Checkbox(
            value: widget.isChecked,
            onChanged: (value){
              widget.onChanged(value);
              setState(() {
                widget.isChecked = value;
              });
            },
          ),
          Text(
            widget.text,
            style: widget.textStyle,
          )
        ],
      ),
    );
  }
}
