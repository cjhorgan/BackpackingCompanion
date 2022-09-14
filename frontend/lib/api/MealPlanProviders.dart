import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/models/hiker.dart';
import '../models/trip.dart';
import '../models/item.dart';
import '../models/meal.dart';
import 'package:http/http.dart' as http;

class MealProvider with ChangeNotifier {
  MealProvider() {
    fetchTasksMeal();
    notifyListeners();
  }
  List<Meal> _meals = [];

  List<Meal> get meals {
    return [..._meals];
  }

  void deleteMeal(Meal meal) async {
    // print('The value of the input is: ${hiker.hiker_id}');
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/meal/${meal.meal_id}/'));

    if (response.statusCode == 204) {
      _meals.remove(meal);
      notifyListeners();
    }
  }

  void addMeal(Meal meal) async {
    print('called');
    print(meal);
    print('called');
    print(jsonEncode(meal));
    final response = await http.post(Uri.parse('http://127.0.0.1:8000/meal/'),
        headers: {"Content-Type": "application/json"}, body: json.encode(meal));

    if (response.statusCode == 200) {
      meal.meal_id = json.decode(response.body)['meal_id'];
      _meals.add(meal);
      notifyListeners();
    }
  }

  void updateMeal(Meal meal) async {
    print('called');
    print(meal);
    print('called');
    print(jsonEncode(meal));
    final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/meal/${meal.meal_id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(meal));

    if (response.statusCode == 201) {
      meal.meal_id = json.decode(response.body)['meal_id'];
      _meals.add(meal);
      notifyListeners();
    }
  }
  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse('http://127.0.0.1:8000/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksMeal() async {
    const url = 'http://127.0.0.1:8000/meal/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _meals = data.map<Meal>((json) => Meal.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class MealPlanProvider extends ChangeNotifier {
  MealPlanProvider() {
    fetchTasksMealPlan();
    notifyListeners();
  }
  List<MealPlan> _mealplans = [];

  List<MealPlan> get mealplans {
    return [..._mealplans];
  }

  void deleteMealplan(MealPlan mealplan) async {
    // print('The value of the input is: ${hiker.hiker_id}');
    final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/mealplan/${mealplan.mealplan_id}/'));

    if (response.statusCode == 204) {
      _mealplans.remove(mealplan);
      notifyListeners();
    }
  }

  void addMeal(MealPlan mealplan) async {
    print('called');
    print(mealplan);
    print('called');
    print(jsonEncode(mealplan));
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/mealplan/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(mealplan));

    if (response.statusCode == 201) {
      mealplan.mealplan_id = json.decode(response.body)['mealplan_id'];
      _mealplans.add(mealplan);
      notifyListeners();
    }
  }

  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse('http://127.0.0.1:8000/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksMealPlan() async {
    const url = 'http://127.0.0.1:8000/mealplan/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _mealplans =
          data.map<MealPlan>((json) => MealPlan.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class MealScheduleProvider extends ChangeNotifier {
  MealScheduleProvider() {
    fetchTasksMealSchedule();
    notifyListeners();
  }
  List<MealSchedule> _mealschedules = [];

  List<MealSchedule> get mealschedules {
    return [..._mealschedules];
  }

  void deleteMealSchedule(MealSchedule mealschedule) async {
    // print('The value of the input is: ${hiker.hiker_id}');
    final response = await http.delete(Uri.parse(
        'http://127.0.0.1:8000/mealschedule/${mealschedule.mealschedule_id}/'));

    if (response.statusCode == 204) {
      _mealschedules.remove(mealschedule);
      notifyListeners();
    }
  }

  void addMealSchedule(MealSchedule mealschedule) async {
    print('called');
    print(mealschedule);
    print('called');
    print(jsonEncode(mealschedule));
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/mealschedule/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(mealschedule));

    if (response.statusCode == 201) {
      mealschedule.mealschedule_id =
          json.decode(response.body)['mealschedule_id'];
      _mealschedules.add(mealschedule);
      notifyListeners();
    }
  }

  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse('http://127.0.0.1:8000/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksMealSchedule() async {
    const url = 'http://127.0.0.1:8000/mealschedule/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _mealschedules = data
          .map<MealSchedule>((json) => MealSchedule.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}

class MealDayProvider extends ChangeNotifier {
  MealDayProvider() {
    fetchTasksMealDay();
    notifyListeners();
  }
  List<MealDay> _mealdays = [];

  List<MealDay> get mealdays {
    return [..._mealdays];
  }

  void deleteMealSchedule(MealDay mealday) async {
    // print('The value of the input is: ${hiker.hiker_id}');
    final response = await http.delete(
        Uri.parse('http://127.0.0.1:8000/mealday/${mealday.mealday_id}/'));

    if (response.statusCode == 204) {
      _mealdays.remove(mealday);
      notifyListeners();
    }
  }

  void addMeal(MealDay mealday) async {
    print('called');
    print(mealday);
    print('called');
    print(jsonEncode(mealday));
    final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/mealday/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(mealday));

    if (response.statusCode == 201) {
      mealday.mealday_id = json.decode(response.body)['mealday_id'];
      _mealdays.add(mealday);
      notifyListeners();
    }
  }

  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse('http://127.0.0.1:8000/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksMealDay() async {
    const url = 'http://127.0.0.1:8000/mealday/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _mealdays = data.map<MealDay>((json) => MealDay.fromJson(json)).toList();

      notifyListeners();
    }
  }
}
