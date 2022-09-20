import 'package:flutter/material.dart';
import 'package:frontend/color_schemes.g.dart';
import 'package:frontend/hikerList.dart';
import 'package:frontend/models/hiker.dart';
import 'package:frontend/models/item.dart';
import 'package:frontend/models/meal.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/api/MealPlanProviders.dart';
import 'package:frontend/api/api.dart';
import 'package:provider/provider.dart';

class MealDetails extends StatelessWidget {
  const MealDetails({super.key, required this.meal});
  final Meal meal;

  @override
  @override
  Widget _buildStack() {
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    return Stack(
      alignment: const Alignment(0, 1),
      children: [
        Container(
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(
                side: BorderSide(width: 10, color: darkColorScheme.outline),
              )),
          child: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://png.pngitem.com/pimgs/s/197-1979886_images-transparent-food-symbol-png-png-download.png'),
            radius: 50,
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: darkColorScheme.surface,
        //   ),
        //   child: const Text(
        //     'hiker_first_name',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget iconButton(IconData icon, String label) {
    return Column(children: [
      IconButton(icon: Icon(icon), onPressed: () {}),
      Text(label)
    ]);
  }

  Widget statsBox(FoodItem food, ItemQuantity quantity) {
    ThemeData(useMaterial3: true, colorScheme: darkColorScheme);
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: darkColorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Meal Component Info",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Food Name:",
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(food.item_name)
                ],
              ),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Description:",
                  style: TextStyle(fontSize: 15),
                ),
                Text(food.item_description)
              ]),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Single Serving Size:",
                  style: TextStyle(fontSize: 15),
                ),
                Text(food.item_weight.toString())
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Number of Servings:",
                  style: TextStyle(fontSize: 15),
                ),
                Text(quantity.item_quantity.toString())
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Total Weight of Servings:",
                  style: TextStyle(fontSize: 15),
                ),
                Text((food.item_weight! * quantity.item_quantity)
                    .toStringAsFixed(2))
              ]),
              const Divider(
                height: 20,
                indent: 2,
                endIndent: 2,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Calories:",
                  style: TextStyle(fontSize: 15),
                ),
                Text((food.calories * quantity.item_quantity).toString() + "g")
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Protein:",
                  style: TextStyle(fontSize: 15),
                ),
                Text((food.protein * quantity.item_quantity).toString() + "g")
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text(
                  "Sugar:",
                  style: TextStyle(fontSize: 15),
                ),
                Text((food.sugar * quantity.item_quantity).toString() + "g")
              ]),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meal = ModalRoute.of(context)!.settings.arguments as Meal;
    final itemQuantP = Provider.of<ItemQuantityProvider>(context);
    final foodItemP = Provider.of<FoodItemProvider>(context);
    var itemquantity = itemQuantP.itemquantitys
        .where((quantObj) => quantObj.meal == meal.meal_id)
        .toList();
    final List<FoodItem> fooditemsList = [];
    for (var food in foodItemP.fooditems) {
      for (var qty in itemquantity) {
        if (qty.item == food.item_id) {
          fooditemsList.add(food);
          break;
        }
      }
    }
    return Scaffold(
        backgroundColor: darkColorScheme.background,
        appBar: AppBar(title: Text("Meal Detail")),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
                margin: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 5),
                child: Center(
                  child: _buildStack(),
                )),
            Center(
                child: Text(meal.meal_name,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: darkColorScheme.onSurface,
                    ))),
            ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: fooditemsList.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                    margin: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 5),
                    height: 400,
                    child: statsBox(fooditemsList[index], itemquantity[index]));
              },
            )
          ],
        )));
    throw UnimplementedError();
  }
}
