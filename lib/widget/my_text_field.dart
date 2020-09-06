import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;

  final String hint;

  final IconData icon;

  final String defaultText;

  final bool isVisible;


  final double fontSize;

  const MyTextField(
      {this.controller,
      this.hint,
      this.icon,
      this.defaultText,
      bool isVisible,
      this.fontSize =20})
      : assert(controller != null),
        isVisible = isVisible == null ? true : false;

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) {
        setState(() {});
      },
      obscureText: !widget.isVisible,
      style: TextStyle(fontSize: ScreenUtil().setSp(widget.fontSize)),
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(fontSize: ScreenUtil().setSp(widget.fontSize)),
          prefixIcon: Icon(widget.icon, size: ScreenUtil().setWidth(widget.fontSize*3/2)),
          suffixIcon: Container(
            child: Offstage(
              offstage: widget.controller.text == "",
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      widget.controller.clear();
                    });
                  }),
            ),
          )),
    );
  }
}
