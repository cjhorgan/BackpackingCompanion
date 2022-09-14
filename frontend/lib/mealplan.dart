import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/api/MealPlanProviders.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:collection/collection.dart';
import 'models/hiker.dart';
import 'models/item.dart';
import 'models/meal.dart';
import 'models/trip.dart';
import 'screens/createMeal.dart';
import 'package:frontend/screens/addItem.dart';
import 'color_schemes.g.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;

class MealPlanScreenProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => TripProvider()),
        ChangeNotifierProvider(create: (_) => HikerProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => FoodItemProvider()),
        ChangeNotifierProvider(create: (_) => ItemQuantityProvider()),
        ChangeNotifierProvider(create: (_) => MealDayProvider()),
        ChangeNotifierProvider(create: (_) => MealScheduleProvider()),
        ChangeNotifierProvider(create: (_) => MealPlanProvider()),
      ],
      child: MealPlanScreen(),
    );
  }
}

enum MealTypes { Breakfast, Lunch, Dinner, Snack }

class MealPlanScreen extends StatefulWidget {
  @override
  _MealplanMealState createState() => _MealplanMealState();
}

class _MealplanMealState extends State<MealPlanScreen> {
  //final int tripId;
  //const _MealplanMealState({super.key});

  late final ValueNotifier<List<List<Meal>>> _selectedMeals;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  List<String> categories = ["Breakfast", "Lunch", "Dinner", "Snack"];

  @override
  void initState() {
    super.initState();

    final tripP = Provider.of<TripProvider>(context, listen: false);
    print("Trip num: ${tripP.trips.length}");
    if (tripP.trips.length != 0) {
      _focusedDay = tripP.trips[0].trip_plan_start_datetime;
    }
    _selectedDay = _focusedDay;
    _selectedMeals = ValueNotifier(_getMealsforDay(_focusedDay));
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<List<Meal>> _getMealsforDay(DateTime day) {
    final mealDayP = Provider.of<MealDayProvider>(context, listen: false);
    //print(mealDayP.mealdays.length);
    final mealScheduleP =
        Provider.of<MealScheduleProvider>(context, listen: false);
    //print(mealScheduleP.mealschedules.length);
    final mealP = Provider.of<MealProvider>(context, listen: false);
    List<Meal> breakfast = [];
    List<Meal> lunch = [];
    List<Meal> dinner = [];
    List<Meal> snack = [];
    List<List<Meal>> meals = [];

    var mealDay = mealDayP.mealdays
        .firstWhereOrNull((element) => isSameDay(element.trip_day, day));
    print('MealDays: ${mealDay}');

    if (mealDay != null) {
      var mealSchedule = mealScheduleP.mealschedules
          .where((schedule) => schedule.day == mealDay.mealday_id)
          .toList();

      for (var schedule in mealSchedule) {
        print(schedule.meal);
        for (var meal in mealP.meals) {
          if (meal.meal_id == schedule.meal &&
              schedule.meal_type == "1" &&
              schedule.day == mealDay.mealday_id) {
            print("BreakFast: ${meal.meal_name}");
            breakfast.add(meal);
          } else if (meal.meal_id == schedule.meal &&
              schedule.meal_type == "2" &&
              schedule.day == mealDay.mealday_id) {
            print("lunch: ${meal.meal_name}");
            lunch.add(meal);
          } else if (meal.meal_id == schedule.meal &&
              schedule.meal_type == "3" &&
              schedule.day == mealDay.mealday_id) {
            print("Dinner: ${meal.meal_name}");
            dinner.add(meal);
          } else if (meal.meal_id == schedule.meal &&
              schedule.meal_type == "4" &&
              schedule.day == mealDay.mealday_id) {
            print("snack: ${meal.meal_name}");
            snack.add(meal);
          }
        }
      }
    }
    meals = [breakfast, lunch, dinner, snack];

    return meals;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = selectedDay;
      });

      _selectedMeals.value = _getMealsforDay(selectedDay);
    }
  }

  String _findMealType(Meal meal, DateTime day) {
    final mealScheduleP =
        Provider.of<MealScheduleProvider>(context, listen: false);
    final mealDayP = Provider.of<MealDayProvider>(context, listen: false);
    var mealDay = mealDayP.mealdays
        .singleWhere((element) => isSameDay(element.trip_day, day));
    var scheduledmeal = mealScheduleP.mealschedules.singleWhere((schedule) =>
        schedule.meal == meal.meal_id && schedule.day == mealDay.mealday_id);

    switch (scheduledmeal.meal_type) {
      case "1":
        {
          return "Breakfast";
        }
        break;
      case "2":
        {
          return "Lunch";
        }
        break;
      case "3":
        {
          return "Dinner";
        }
        break;
      case "4":
        {
          return "Snack";
        }
        break;
      default:
        {
          return "NotFound";
        }
        break;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    Color textColor = Theme.of(context).colorScheme.onSurfaceVariant;
    Color headlineColor = Theme.of(context).colorScheme.onSurface;
    final mealplanP = Provider.of<MealPlanProvider>(context);
    final hikerP = Provider.of<HikerProvider>(context);
    final tripP = Provider.of<TripProvider>(context);
    final mealdayP = Provider.of<MealDayProvider>(context);
    final mealschP = Provider.of<MealScheduleProvider>(context);
    final mealP = Provider.of<MealProvider>(context);
    final itemQuantP = Provider.of<ItemQuantityProvider>(context);
    final foodItemP = Provider.of<FoodItemProvider>(context);
    final invP = Provider.of<InventoryProvider>(context);
    Hiker curHiker = hikerP.hikers[0];
    Trip curTrip = tripP.trips[0];
    print(curTrip.trip_id);
    MealDay curMealDay = mealdayP.mealdays
        .singleWhere((element) => isSameDay(element.trip_day, _selectedDay));
    MealPlan curMealPlan = mealplanP.mealplans.singleWhere((mealplan) =>
        mealplan.mealplan_trip == curTrip.trip_id &&
        mealplan.mealplan_hiker == curHiker.hiker_id);
    Inventory curInventory = invP.inventorys[0];
    print(curTrip.trip_plan_start_datetime);
    return Scaffold(
      backgroundColor: darkColorScheme.surface,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Center(child: const Text('Add Meal')),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealForm(
                            mealplan: curMealPlan,
                            curTrip: curTrip,
                            curDay: _focusedDay,
                            curHiker: curHiker,
                            curInventory: curInventory,
                          )),
                ),
                child: const Text('New Meal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Existing Meal'),
                child: const Text('Existing Meal'),
              ),
            ],
          ),
        ),
        tooltip: 'Add New Meal',
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("${curHiker.hiker_first_name}'s MealPlan "),
        actions: [],
      ),
      body: Column(
        children: [
          Card(
              child: ListTile(
            title: Text(
              "Current Day:${_focusedDay.month}/${_focusedDay.day}/${_focusedDay.year}",
              style: TextStyle(
                color: Colors.green,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
                "Total Calories:${curMealPlan.total_trip_calories}\nCurrent Daily Scheduled Calories :${curMealDay.daily_caloric_scheduled}\n${curHiker.hiker_first_name}'s Estimated Required: ${curMealPlan.est_daily_minimum_cal_required}"),
          )),
          TableCalendar<List<Meal>>(
            firstDay: curTrip.trip_plan_start_datetime,
            lastDay: curTrip.trip_plan_end_datetime,
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.week,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getMealsforDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              // Use `CalendarStyle` to customize the UI
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<List<Meal>>>(
              valueListenable: _selectedMeals,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(
                        categories[index],
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                        ),
                      ),
                      initiallyExpanded: true,
                      children: <Widget>[
                        Column(
                          children: _buildExpandableList(value[index]),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildExpandableList(List<Meal> list) {
    List<Widget> content = [];

    list.forEach(
      (item) => content.add(ListTile(
        leading: ButtonTheme(
          minWidth: 20.0,
          height: 20.0,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                minimumSize: Size(10, 10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FoodDetailScreen(todo: item)),
                );
              },
              child: Text("edit")),
        ),
        title: Text(item.meal_name),
        // trailing: FloatingActionButton.small(
        //   onPressed: () {},
        //   backgroundColor: Colors.red,
        //   child: const Icon(Icons.delete),
        // )
      )),
    );

    return content;
  }
}

class FoodDetailScreen extends StatelessWidget {
  // In the constructor, require a Todo.
  const FoodDetailScreen({super.key, required this.todo});

  // Declare a field that holds the Todo.
  final Meal todo;

  @override
  Widget build(BuildContext context) {
    final itemQuantP = Provider.of<ItemQuantityProvider>(context);
    final foodItemP = Provider.of<FoodItemProvider>(context);
    var itemquantity = itemQuantP.itemquantitys
        .where((quantObj) => quantObj.meal == todo.meal_id)
        .toList();
    print("Filtered: ${itemquantity.length}");
    print("FoodItems: ${foodItemP.fooditems[3].item_id}");
    final List<FoodItem> fooditemsList = [];

    for (var food in foodItemP.fooditems) {
      for (var qty in itemquantity) {
        if (qty.item == food.item_id) {
          fooditemsList.add(food);
          break;
        }
      }
    }

    print("FoodItemsQTY:${fooditemsList.length}");
    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: Text(
              "Meal : ${todo.meal_name}\nCalories : ${todo.total_calories}\nProtein : ${todo.total_protein}"),
          toolbarHeight: 210,
        ),
        body: ListView.builder(
            itemCount: fooditemsList.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                  child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text("Item Name"),
                    subtitle: Text(fooditemsList[index].item_name),
                  ),
                  ListTile(
                    title: Text("Item Id"),
                    subtitle: Text("${fooditemsList[index].item_id}"),
                  ),
                  ListTile(
                    title: Text("Item Weight"),
                    subtitle: Text("${fooditemsList[index].item_weight}"),
                  ),
                  ListTile(
                    title: Text("Item Category"),
                    subtitle: Text("${fooditemsList[index].item_category}"),
                  ),
                  ListTile(
                    title: Text("Item Description"),
                    subtitle: Text(fooditemsList[index].item_description),
                  ),
                  ListTile(
                    title: Text("Calories"),
                    subtitle: Text("${fooditemsList[index].calories}"),
                  ),
                  ListTile(
                    title: Text("Protein"),
                    subtitle: Text("${fooditemsList[index].protein}"),
                  ),
                  ListTile(
                    title: Text("Sugar"),
                    subtitle: Text("${fooditemsList[index].sugar}"),
                  ),
                ],
              ));
            }));
  }
}
