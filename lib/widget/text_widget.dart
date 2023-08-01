import 'package:flutter/material.dart';
import 'package:local_db_sample/widget/responsive/responsive.dart';
import 'package:local_db_sample/widget/style_color.dart';



Widget getBodyBoldText(BuildContext context, text1, text2) {
  return RichText(
    maxLines: 3,
    text: TextSpan(
      children: [
        TextSpan(
          text: text1,
          style: Responsive.isMobile(context)
              ? bodyBlackMobileStyle
              : bodyBlackTabletStyle,
        ),
        TextSpan(
          text: text2,
          style: Responsive.isMobile(context)
              ? bodyBoldBlackMobileStyle
              : bodyBoldBlackTabletStyle,
        ),
      ],
    ),
  );
}


Widget getDesignationText(BuildContext context, text1, text2) {
  return RichText(
    // maxLines: 2,
    text: TextSpan(
      children: [
        TextSpan(
          text: text1,
          style: Responsive.isMobile(context)
              ? bodyGreenMobileStyle
              : bodyGreenTabletStyle,
        ),
        TextSpan(
          text:  text2,
          style: Responsive.isMobile(context)
              ? bodyBoldGreenMobileStyle
              : bodyBoldGreenTabletStyle,
        ),
      ],
    ),
  );
}


