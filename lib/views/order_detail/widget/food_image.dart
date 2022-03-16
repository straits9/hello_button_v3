import 'package:flutter/material.dart';
import 'package:hello_button_v3/config.dart';
import 'package:hello_button_v3/models/food.dart';

class FoodImg extends StatelessWidget {
  final Food? food;
  FoodImg({this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                    color: AppConfig.kBackground,
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.all(15),
                width: 220,
                height: 220,
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(-1, 10),
                    blurRadius: 10,
                  )
                ]),
                child: food!.imgUrl.toString().startsWith('https://')
                    ? Image.network(
                        food!.imgUrl!,
                        fit: BoxFit.fill,
                      )
                    : Image.asset(
                        food!.imgUrl!,
                        fit: BoxFit.cover,
                      )),
          )
        ],
      ),
    );
  }
}
