import 'package:flutter/material.dart';
import 'package:hello_button_v3/config.dart';
import 'package:hello_button_v3/models/food.dart';

class FoodItem extends StatelessWidget {
  final Food food;
  const FoodItem({
    Key? key,
    required this.food,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            width: 110,
            height: 110,
            child: food.imgUrl.toString().startsWith('https://')
                ? Image.network(
                    food.imgUrl.toString(),
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    food.imgUrl.toString(),
                    fit: BoxFit.fitHeight,
                  ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        food.name.toString(),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.5),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15,
                      )
                    ],
                  ),
                  Text(
                    food.desc.toString(),
                    style: TextStyle(
                        color: food.highLight
                            ? AppConfig.kPrimaryColor
                            : Colors.grey.withOpacity(0.8)),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Text(
                        '\$',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        food.price.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
