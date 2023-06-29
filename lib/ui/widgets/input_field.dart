import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_to_do_app/ui/themes.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  const MyInputField(
      {super.key,
      required this.title,
      required this.hint,
      this.controller,
      this.widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: subHeadingStyle,
          ),
          SizedBox(height: 10),
          Container(
            height: 52,
            padding: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              Expanded(
                  child: TextFormField(
                readOnly: widget == null ? false : true,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subHeadingStyle,
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  //contentPadding: EdgeInsets.only(left: 20)
                ),
                autofocus: false,
                cursorColor: Colors.black,
                controller: controller,
                style: subHeadingStyle,
              )),
              widget == null ? Container() : Container(child: widget)
            ]),
          ),
        ],
      ),
    );
  }
}
