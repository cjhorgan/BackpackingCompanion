import 'package:flutter/material.dart';
import 'package:frontend/api/api.dart';
import 'package:frontend/api/MealPlanProviders.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/BottomTrav.dart';
import 'package:frontend/layout.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:collection/collection.dart';
import 'package:frontend/screens/mealDetailsScreen.dart';
import 'models/hiker.dart';
import 'models/item.dart';
import 'models/meal.dart';
import 'models/trip.dart';
import 'screens/createMeal.dart';
import 'package:frontend/screens/addItem.dart';
import 'color_schemes.g.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:collection/collection.dart';
// class MealPlanScreenProvider extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => ItemProvider()),
//         ChangeNotifierProvider(create: (_) => TripProvider()),
//         ChangeNotifierProvider(create: (_) => HikerProvider()),
//         ChangeNotifierProvider(create: (_) => MealProvider()),
//         ChangeNotifierProvider(create: (_) => FoodItemProvider()),
//         ChangeNotifierProvider(create: (_) => ItemQuantityProvider()),
//         ChangeNotifierProvider(create: (_) => MealDayProvider()),
//         ChangeNotifierProvider(create: (_) => MealScheduleProvider()),
//         ChangeNotifierProvider(create: (_) => MealPlanProvider()),
//       ],
//       child: MealPlanScreen(),
//       );
//   }
// }

enum MealTypes { Breakfast, Lunch, Dinner, Snack }

class MealPlanScreen extends StatefulWidget {
  final MealPlan? mealplan;
  final Trip curTrip;
  final Hiker curHiker;
  final Inventory? curInventory;
  const MealPlanScreen(
      {Key? key,
      this.mealplan,
      required this.curTrip,
      required this.curHiker,
      this.curInventory})
      : super(key: key);
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

  int _selectedIndex = 0;

  var _selectedMeal;
  String mealtypedropdown = 'Breakfast';
  String dateDropDown = '';
  List<String> dateList = [];
  var day = 0;
  var mealplan = 0;
  String meal_type = "";

  @override
  void initState() {
    super.initState();

    _focusedDay = widget.curTrip.trip_plan_start_datetime;

    _selectedDay = _focusedDay;
    _selectedMeals = ValueNotifier(_getMealsforDay(_focusedDay));
    dateList = calculateDaysInterval(widget.curTrip.trip_plan_start_datetime,
        widget.curTrip.trip_plan_end_datetime);
    dateDropDown = dateList[0];
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

  List<String> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<String> days = [];

    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(
          '${startDate.add(Duration(days: i)).month}/${startDate.add(Duration(days: i)).day}/${startDate.add(Duration(days: i)).year}');
    }
    dateDropDown = days[0];
    return days;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = selectedDay;
        _selectedMeals.value = _getMealsforDay(_selectedDay!);
      });
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

  void _onItemTapped(int index) {
    final hiker = ModalRoute.of(context)!.settings.arguments as Hiker;

    setState(() {
      (context) => Layout(hiker: hiker);
      _selectedIndex = index;
    });
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
    MealDay? curMealDay = mealdayP.mealdays.singleWhereOrNull(
        (element) => isSameDay(element.trip_day, _selectedDay));
    MealPlan? curMealPlan = mealplanP.mealplans.singleWhereOrNull((mealplan) =>
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
                onPressed: () async => await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MealForm(
                            mealplan: curMealPlan!,
                            curTrip: curTrip,
                            curDay: _focusedDay,
                            curHiker: curHiker,
                            curInventory: curInventory,
                          )),
                ).then((_) => setState(() {})),
                child: const Text('New Meal'),
              ),
              ElevatedButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                        title:
                            Center(child: const Text("Add Existing Meal...")),
                        content: SingleChildScrollView(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Meal',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                    DropdownButton<Meal>(
                                        value: mealP.meals.first,
                                        icon: const Icon(Icons.arrow_downward),
                                        elevation: 16,
                                        style: const TextStyle(),
                                        underline: Container(
                                          height: 2,
                                        ),
                                        onChanged: (Meal? newValue) {
                                          setState(() {
                                            _selectedMeal = newValue!.meal_id;
                                            print(_selectedMeal);
                                          });
                                        },
                                        items: mealP.meals
                                            .map<DropdownMenuItem<Meal>>(
                                                (Meal value) {
                                          return DropdownMenuItem<Meal>(
                                            value: value,
                                            child: Text(value.meal_name),
                                          );
                                        }).toList()),
                                  ]),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('MealType:',
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
                                          switch (newValue) {
                                            case "Breakfast":
                                              {
                                                meal_type = '1';
                                              }
                                              break;
                                            case "Lunch":
                                              {
                                                meal_type = '2';
                                              }
                                              break;
                                            case "Dinner":
                                              {
                                                meal_type = '3';
                                              }
                                              break;
                                            case "Snack":
                                              {
                                                meal_type = '4';
                                              }
                                              break;
                                            default:
                                              {
                                                meal_type = '1';
                                              }
                                              break;
                                          }
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
                                          day = mealdayP.mealdays
                                              .singleWhere((mealday) =>
                                                  "${mealday.trip_day.month}/${mealday.trip_day.day}/${mealday.trip_day.year}" ==
                                                  newValue)
                                              .mealday_id!;
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
                            ], //Cplumn children
                          ),
                        ))),
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
                "Total Calories:${curMealPlan!.total_trip_calories}\nCurrent Daily Scheduled Calories :${curMealDay?.daily_caloric_scheduled}\n${curHiker.hiker_first_name}'s Estimated Required: ${curMealPlan.est_daily_minimum_cal_required}"),
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
              setState(() {
                _focusedDay = focusedDay;
                _getMealsforDay(_focusedDay);
              });
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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkColorScheme.surface,
        elevation: 15,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.forest),
            label: 'Trip',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Navigation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: darkColorScheme.primary,
      ),
    );
  }

  _buildExpandableList(List<Meal> list) {
    List<Widget> content = [];

    list.forEach(
      (item) => content.add(Card(
          child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.check_box),
          onPressed: () {},
        ),
        title: Text(item.meal_name),
        subtitle: Text("Calories: ${item.total_calories}"),
        trailing: ButtonTheme(
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MealDetails(meal: item),
                settings: RouteSettings(arguments: item)),
          );
        },
        // trailing: FloatingActionButton.small(
        //   onPressed: () {},
        //   backgroundColor: Colors.red,
        //   child: const Icon(Icons.delete),
        // )
      ))),
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
          toolbarHeight: 120,
        ),
        body: ListView.builder(
            itemCount: fooditemsList.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                  child: Column(
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 20.0,
                    height: 20.0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          minimumSize: Size(10, 10),
                        ),
                        onPressed: () {
                          //Navigator.push(
                          //context,
                          ///MaterialPageRoute(
                          // builder: (context) =>
                          //    ),
                          //);
                        },
                        child: Text("edit")),
                  ),
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
