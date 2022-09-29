import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/models/hiker.dart';
import 'package:frontend/models/meal.dart';
import 'package:intl/intl.dart' as intl;
import 'package:frontend/api/api.dart';
import 'package:frontend/api/MealPlanProviders.dart';
import 'package:collection/collection.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/models/item.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:multiselect_formfield/multiselect_dialog.dart';
import 'package:provider/provider.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MealForm extends StatefulWidget {
  final MealPlan mealplan;
  final Trip curTrip;
  final DateTime curDay;
  final Hiker curHiker;
  final Inventory? curInventory;

  const MealForm(
      {Key? key,
      required this.mealplan,
      required this.curTrip,
      required this.curDay,
      required this.curHiker,
      this.curInventory})
      : super(key: key);

  @override
  _MealFormState createState() => _MealFormState();
}

class _MealFormState extends State<MealForm> {
  //Props for Meal
  String meal_name = "";
  var _meal_components = [];
  final meal_nameController = TextEditingController();

  //Props for MealSchedule
  var meal = 0;
  var day = 0;
  var mealplan = 0;
  String meal_type = "";
  String mealtypedropdown = 'Breakfast';
  String dateDropDown = '';
  List<String> dateList = [];

  //Props Food Item
  final fooditem_nameController = TextEditingController();
  final fooditem_DescController = TextEditingController();
  final isEssential = false;
  bool _isFavorite = false;
  var calories = 0;
  var protein = 0;
  var sugar = 0;
  var item_weight = 0.0;

  //ItemQuantity
  var _selectedMeals = [];
  List<int> _selectedMealsQty = [];
  @override
  void initState() {
    // TODO: implement initState
    final fooditemP = Provider.of<FoodItemProvider>(context, listen: false);
    dateList = calculateDaysInterval(widget.curTrip.trip_plan_start_datetime,
        widget.curTrip.trip_plan_end_datetime);
    dateDropDown = dateList[0];
    _isFavorite = false;
    super.initState();
  }

  void addMeal() {
    final Meal newMeal = Meal(
        meal_name: meal_nameController.text,
        meal_components: _meal_components,
        meal_isConsumed: false);

    final MealSchedule newSch = MealSchedule(
        meal: meal, mealplan: mealplan, day: day, meal_type: meal_type);

    Provider.of<MealProvider>(context, listen: false).addMeal(newMeal);
    Provider.of<MealScheduleProvider>(context, listen: false)
        .addMealSchedule(newSch);
  }

  void addFoodItem() {
    final fooditemP = Provider.of<FoodItemProvider>(context, listen: false);

    final FoodItem newFood = FoodItem(
        item_name: fooditem_nameController.text,
        item_description: fooditem_DescController.text,
        item_weight: item_weight,
        isEssential: false,
        isFavorite: _isFavorite,
        item_category: "Food",
        calories: calories,
        protein: protein,
        sugar: sugar);

    fooditemP.addFoodItem(newFood);
    var foodref = fooditemP.fooditems
        .singleWhereOrNull((food) => food.item_name == newFood.item_name);
    _meal_components.add(foodref?.item_id);
  }

  void _addSelectedMeals(List<dynamic> meals) {
    final foodItemP = Provider.of<FoodItemProvider>(context, listen: false);
    _selectedMeals = [];
    for (var index in meals) {
      print("index: ${index}");
      foodItemP.fooditems.forEach((food) {
        if (food.item_id.toString() == index.toString()) {
          print(food.item_id.toString() == index.toString());
          _selectedMeals.add(food.item_name);
          _selectedMealsQty.add(0);
        }
      });
    }
    print("SelectedMealLenth:${_selectedMeals.length}");
  }

  void _createMeal() {
    final invP = Provider.of<InventoryProvider>(context, listen: false);
    final fooditemP = Provider.of<FoodItemProvider>(context, listen: false);
    List<dynamic> itemQty = [];
    Meal newMeal =
        Meal(meal_name: meal_nameController.text, meal_isConsumed: false);
    int inventory = 0;
    Provider.of<MealProvider>(context, listen: false).addMeal(newMeal);
    final mealP = Provider.of<MealProvider>(context, listen: false);
    var curCreatedMeal = mealP.meals.last;

    for (int i = 0; i < _selectedMealsQty.length; i++) {
      bool isMultiple = false;

      print("meal:${_meal_components[i]}");
      if (_selectedMealsQty[i] > 1) {
        isMultiple = true;
      }
      print("On to ItemQuantity");
      ItemQuantity newitemQty = ItemQuantity(
          inventory: 2,
          item_quantity: _selectedMealsQty[i].toInt(),
          item: int.parse(_meal_components[i]),
          item_note: '',
          meal: curCreatedMeal.meal_id!.toInt(),
          isMultiple: isMultiple);

      Provider.of<ItemQuantityProvider>(context, listen: false)
          .addItemQuantity(newitemQty);
      itemQty.add((Provider.of<ItemQuantityProvider>(context, listen: false)
          .itemquantitys
          .singleWhere((qty) =>
              qty.item == newitemQty.item && qty.meal == newitemQty.meal)).id);
    }
    newMeal.meal_components = itemQty;
    Provider.of<MealProvider>(context, listen: false).updateMeal(newMeal);

    if (curCreatedMeal != null) {
      int meal = curCreatedMeal.meal_id!.toInt();
    }
    MealSchedule newMealSchedule = MealSchedule(
        meal: meal,
        mealplan: widget.mealplan.mealplan_id!.toInt(),
        day: day,
        meal_type: meal_type);
  }

  List<String> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<String> days = [];

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
          '${startDate.add(Duration(days: i)).month}/${startDate.add(Duration(days: i)).day}/${startDate.add(Duration(days: i)).year}');
    }
    dateDropDown = days[0];
    return days;
  }

  @override
  Widget build(BuildContext context) {
    String focusedDay =
        "${widget.curDay.month}/${widget.curDay.day}/${widget.curDay.year}";
    final fooditemP = Provider.of<FoodItemProvider>(context);
    final mealDayP = Provider.of<MealDayProvider>(context);

    var multiselectfoodmap =
        fooditemP.fooditems.map((food) => food.toJson()).toList();
    var seen = Set<String>();
    List<String> uniqueDates =
        dateList.where((date) => seen.add(date)).toList();

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              _createMeal();
            },
            label: const Text("Create"),
            heroTag: "creatmealSubmit",
            icon: Icon(Icons.add_box)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: const Text('Create a Meal'),
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
              child: (Form(
            child: Scrollbar(
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...[
                            Column(children: [
                              TextFormField(
                                controller: meal_nameController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  hintText: 'Name of Meal...',
                                  labelText: 'Meal Name',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    meal_name = value;
                                  });
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('MealType',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  DropdownButton<String>(
                                      value: mealtypedropdown,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(),
                                      underline: Container(
                                        height: 2,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          mealtypedropdown = newValue!;
                                        });
                                      },
                                      items: <String>[
                                        'Breakfast',
                                        'Lunch',
                                        'Dinner',
                                        'Snack'
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Date:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  DropdownButton<String>(
                                      value: dateDropDown,
                                      icon: const Icon(Icons.arrow_downward),
                                      elevation: 16,
                                      style: const TextStyle(),
                                      underline: Container(
                                        height: 2,
                                      ),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          dateDropDown = newValue!;
                                        });
                                      },
                                      items: dateList
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(16),
                                child: MultiSelectFormField(
                                  title: Text(
                                    "Select Food to be added",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  dataSource: multiselectfoodmap,
                                  textField: 'item_name',
                                  valueField: 'item_id',
                                  initialValue: _meal_components,
                                  onSaved: (value) {
                                    if (value == null) return;
                                    setState(() {
                                      _meal_components = value;
                                      print(_meal_components[0]);
                                      _addSelectedMeals(_meal_components);
                                    });
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                      child: Text("Create New Food"),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(builder:
                                                  ((context, setState) {
                                                return AlertDialog(
                                                  content: Stack(
                                                    children: <Widget>[
                                                      Positioned(
                                                        right: -40.0,
                                                        top: -40.0,
                                                        child: InkResponse(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: CircleAvatar(
                                                            child: Icon(
                                                                Icons.close),
                                                            backgroundColor:
                                                                Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      Form(
                                                        child:
                                                            SingleChildScrollView(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(25),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Text("New Food"),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      fooditem_nameController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    hintText:
                                                                        'Name of Food...',
                                                                    labelText:
                                                                        'Food Name',
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      fooditem_DescController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    filled:
                                                                        true,
                                                                    hintText:
                                                                        'Name of Meal...',
                                                                    labelText:
                                                                        'Description',
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: SpinBox(
                                                                  min: 0.00,
                                                                  max: 10.00,
                                                                  value: 1,
                                                                  decimals: 2,
                                                                  step: .01,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Weight(lbs)',
                                                                    labelText:
                                                                        'Weight(lbs)',
                                                                  ),
                                                                  onChanged: (value) =>
                                                                      item_weight =
                                                                          value,
                                                                ),
                                                              ),
                                                              Padding(
                                                                child: SpinBox(
                                                                  min: 1,
                                                                  max: 5000,
                                                                  value: 100,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Calories',
                                                                    labelText:
                                                                        'Calories',
                                                                  ),
                                                                  onChanged: (value) =>
                                                                      calories =
                                                                          value
                                                                              .toInt(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(16),
                                                              ),
                                                              Padding(
                                                                child: SpinBox(
                                                                  min: 1,
                                                                  max: 100,
                                                                  value: 10,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Protein',
                                                                    labelText:
                                                                        'Protein',
                                                                  ),
                                                                  onChanged: (value) =>
                                                                      protein =
                                                                          value
                                                                              .toInt(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(16),
                                                              ),
                                                              Padding(
                                                                child: SpinBox(
                                                                  min: 1,
                                                                  max: 100,
                                                                  value: 5,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    hintText:
                                                                        'Sugar',
                                                                    labelText:
                                                                        'Sugar',
                                                                  ),
                                                                  onChanged:
                                                                      (value) =>
                                                                          sugar =
                                                                              value.toInt(),
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(16),
                                                              ),
                                                              SwitchListTile(
                                                                title:
                                                                    const Text(
                                                                  'Favorite',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10),
                                                                ),
                                                                value:
                                                                    _isFavorite,
                                                                onChanged: (bool
                                                                    value) {
                                                                  setState(() {
                                                                    _isFavorite =
                                                                        value;
                                                                    print(
                                                                        "isFav: ${_isFavorite}");
                                                                  });
                                                                },
                                                                secondary:
                                                                    const Icon(
                                                                        Icons
                                                                            .star),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(16),
                                                                child:
                                                                    ElevatedButton(
                                                                  child: Text(
                                                                      "Submitß"),
                                                                  onPressed:
                                                                      () {
                                                                    addFoodItem();
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }));
                                            });
                                      },
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    child: ElevatedButton(
                                        child: Text("Add Food Qty"),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text("Item Quantities"),
                                                  content:
                                                      Stack(children: <Widget>[
                                                    Positioned(
                                                      right: -40.0,
                                                      top: -40.0,
                                                      child: InkResponse(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: CircleAvatar(
                                                          child:
                                                              Icon(Icons.close),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.all(4.0),
                                                      child: Container(
                                                          width: 500,
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  physics:
                                                                      ScrollPhysics(),
                                                                  itemCount:
                                                                      _selectedMeals
                                                                          .length,
                                                                  itemBuilder:
                                                                      (BuildContext
                                                                              context,
                                                                          index) {
                                                                    return Padding(
                                                                        padding:
                                                                            EdgeInsets.all(16),
                                                                        child: SpinBox(
                                                                            min: 0,
                                                                            max: 100,
                                                                            value: _selectedMealsQty[index].toDouble(),
                                                                            decoration: InputDecoration(
                                                                              hintText: _selectedMeals[index],
                                                                              labelText: _selectedMeals[index],
                                                                            ),
                                                                            onChanged: (value) => _selectedMealsQty[index] = value.toInt()));
                                                                  })),
                                                    )
                                                  ]),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Ok'))
                                                  ],
                                                );
                                              });
                                        }),
                                  )
                                ],
                              )
                            ])
                          ].expand(
                              (widget) => [widget, const SizedBox(height: 40)])
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ))),
        ));
  }
}
