
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/size_config.dart';
import '../utils/text_styles.dart';



class CustomButtonWithGradient extends StatelessWidget {
  final double? height;
  final double? width;
  final double? roundCorner;
  final String text;
  final double? fontSize;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  void Function() onPressed;
  final bool? gradientt;
  final FontWeight? fontWeight;

  CustomButtonWithGradient(
      {this.height,
      this.width,
      required this.text,
      this.fontSize,
      this.borderColor,
      this.textColor,
      this.roundCorner,
      this.color,
      required this.onPressed,
      Key? key,
      this.gradientt,
      this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
   SizeConfig().init(context);
    return Container(
      height: height ?? getHeight(52),
      width: width ?? getWidth(334),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(roundCorner ?? getHeight(8)),
              border: borderColor != null ? Border.all(color: borderColor!) : null,

            gradient: LinearGradient(
              stops: const [0.1, 1.0],
              colors: [primaryColor.withOpacity(0.6), blue],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),),

      child: MaterialButton(
        shape: const RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(roundCorner ?? 30),
            ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textColor == null
              ? kSize20WhiteW400Text
              : kSize20WhiteW400Text.copyWith(color: textColor),
        ),
      ),
    );
  }
}
