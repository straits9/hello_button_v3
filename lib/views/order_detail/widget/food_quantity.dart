import 'package:flutter/material.dart';
import 'package:hello_button_v3/config.dart';
import 'package:hello_button_v3/models/food.dart';

class FoodQuantity extends StatelessWidget {
  final Food? food;
  const FoodQuantity({
    Key? key,
    this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        height: 40,
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(-0.3, 0),
              child: Container(
                height: double.maxFinite,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(children: [
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    '\$',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    food!.price!.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ]),
              ),
            ),
            Align(
              alignment: const Alignment(0.1, 0),
              child: Container(
                height: double.maxFinite,
                width: 100,
                decoration: BoxDecoration(
                  color: AppConfig.kPrimaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      '-',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Text(
                        food!.quantity!.toString(),
                      ),
                    ),
                    const Text(
                      '+',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
