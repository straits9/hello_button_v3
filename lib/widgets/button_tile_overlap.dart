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
      key: Key(button.title),
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(round)),
      child: InkWell(
        onTap: () async {
          ontap.call(button);
        },
        child: buildBlurredImage1(),
      ),
    );
  }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 3,
    double sigmaY = 3,
  }) =>
      ClipRRect(
        borderRadius: BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );

  Widget buildBlurredImage2() => Container(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(round),
          child: Stack(
            children: [
              if (button.image != null)
                Image.network(
                  ImageHelper.urlFix(button.image!),
                  fit: BoxFit.fill,
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: buildBlur(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      color: Colors.black.withOpacity(0.3),
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
            ],
          ),
        ),
      );

  Container buildBlurredImage1() {
    return Container(
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
    );
  }
}
