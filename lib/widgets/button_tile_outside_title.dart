// button을 조금더 길게 만들고 상부에 image를 정사각형으로 배치하고, image를 벗어난 하단에 title을 표시하는 button
import 'package:flutter/material.dart';
import 'package:hello_button_v3/helpers/image_helper.dart';
import 'package:hello_button_v3/models/button.dart';

class ButtonTileOutsideTitle extends StatelessWidget {
  final Button button;
  final Function(Button) ontap;
  const ButtonTileOutsideTitle({
    Key? key,
    required this.button,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(button.title),
      elevation: 0,
      // color: Colors.white,
      child: IntrinsicHeight(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: constraints.maxWidth,
                // color: Colors.yellow,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(ImageHelper.urlFix(button.image!),
                      fit: BoxFit.cover),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      button.title.replaceAll("<BR>", '\n'),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
