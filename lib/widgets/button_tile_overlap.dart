// image를 background로 처리하고 그 위 하단에 title을 표시하는 button
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hello_button_v3/helpers/image_helper.dart';
import 'package:hello_button_v3/models/button.dart';

class ButtonTileOverlap extends StatelessWidget {
  final Button button;
  final Function(Button) ontap;
  const ButtonTileOverlap(
    Key key,
    this.button,
    this.ontap,
  ) : super(key: key);

  final double round = 20.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(round)),
      child: InkWell(
        onTap: () async {
          ontap.call(button);
        },
        child: Container(
          decoration: button.image == null
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(round),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(ImageHelper.urlFix(button.image!))),
                ),

          // image 위에 text를 배치하기 위해서 text에 대한 alignment와
          // background image와의 분별력을 위해서 적당한 opacity의 block과 blur filter를
          // 배치하여 그 위에 text를 drawing한다
          alignment: Alignment.bottomCenter,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(round),
                bottomRight: Radius.circular(round)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                width: double.infinity,
                color: const Color.fromRGBO(0, 0, 0, 0.2),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  // 기존 data에 line feed를 <BR>로 표기하였기 때문에 replace 필요
                  child: Text(
                    button.title.replaceAll("<BR>", '\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
