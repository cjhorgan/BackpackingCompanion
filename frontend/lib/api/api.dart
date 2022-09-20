import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/models/hiker.dart';
import '../models/trip.dart';
import '../models/item.dart';
import 'package:http/http.dart' as http;

const String target = 'http://10.0.2.2:8000';

//http://10.0.2.2:8000
class ItemProvider with ChangeNotifier {
  ItemProvider() {
    fetchTasks();
    notifyListeners();
  }
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }

  void addItem(Item item) async {
    print(jsonEncode(item));

    final response = await http.post(Uri.parse(target + '/item/'),
        headers: {"Content-Type": "application/json"}, body: json.encode(item));
    print(response.body);
    if (response.statusCode == 201) {
      item.item_id = json.decode(response.body)['item_id'];
      _items.add(item);
      notifyListeners();
    }
  }

  void deleteTodo(Item item) async {
    print('The value of the input is: ${item.item_id}');
    final response =
        await http.delete(Uri.parse(target + '/item/${item.item_id}'));

    if (response.statusCode == 204) {
      _items.remove(item);
      notifyListeners();
    }
  }

  fetchTasks() async {
    const url = (target + '/item/?format=json');
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _items = data.map<Item>((json) => Item.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class TripProvider with ChangeNotifier {
  TripProvider() {
    fetchTasksTrip();
    notifyListeners();
  }
  List<Trip> _trips = [];

  List<Trip> get trips {
    return [..._trips];
  }

  String error = '';

  void deleteTrip(Trip trip) async {
    print('The value of the input is: ${trip.trip_id}');
    final response =
        await http.delete(Uri.parse(target + '/trip/${trip.trip_id}/'));

    if (response.statusCode == 204) {
      _trips.remove(trip);
      notifyListeners();
    }
  }

  String getErrorMessage() {
    return error;
  }

  Future<Trip> updateTrip(int? i, Trip trip) async {
    List<dynamic>? p = trip.trip_hikers;

    p?.add(i);

    final response =
        await http.put(Uri.parse(target + '/trip/${trip.trip_id}/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              'trip_hikers': p,
              'trip_name': trip.trip_name,
              'trip_plan_start_datetime':
                  trip.trip_plan_start_datetime.toString(),
              'trip_plan_end_datetime': trip.trip_plan_end_datetime.toString()
            }));
    if (response.statusCode == 201) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      notifyListeners();
      return Trip.fromJson(jsonDecode(response.body));
    } else {
      print(jsonEncode(trip));
      print("Body: " + response.body);
      print("Code: " + response.statusCode.toString());
      // If the server did not return a 200 OK response,
      // then throw an exception.
      notifyListeners();
      throw Exception('Failed to update album.');
    }
  }

  Trip getTrip(int? id) {
    int n = 0;
    for (int i = 0; i < _trips.length; i++) {
      if (id == _trips.elementAt(i).trip_id) {
        Trip p = _trips[i];
        id = p.trip_id;
        n = i;
        break;
      } else {
        print("notFound");
      }
    }
    return _trips[n];
  }

  void addTrip(Trip trip) async {
    print('called');
    print(jsonEncode(trip));
    print(trip.trip_plan_start_datetime);
    print(trip.trip_plan_end_datetime);
    final response = await http.post(Uri.parse(target + '/trip/'),
        headers: {"Content-Type": "application/json"}, body: json.encode(trip));

    if (response.statusCode == 201) {
      trip.trip_id = json.decode(response.body)['trip_id'];
      _trips.add(trip);
      notifyListeners();
    }
    print(jsonEncode(trip));
    print("Body: " + response.body);
    print("Code: " + response.statusCode.toString());
  }

  Future<String> getError(Trip trip) async {
    String n;
    String message;

    print('called');
    print(jsonEncode(trip));
    print(trip.trip_plan_start_datetime);
    print(trip.trip_plan_end_datetime);
    final response = await http.post(Uri.parse(target + '/trip/'),
        headers: {"Content-Type": "application/json"}, body: json.encode(trip));

    if (response.statusCode == 201) {
      error = "Good Job";
      trip.trip_id = json.decode(response.body)['trip_id'];
      _trips.add(trip);
      notifyListeners();
    } else {
      print(jsonEncode(trip));
      error = json.decode(response.body)["detail"];
    }
    n = (response.statusCode.toString());

    return n;
  }

  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse(target+'/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksTrip() async {
    const url = 'http://10.0.2.2:8000/trip/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _trips = data.map<Trip>((json) => Trip.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class FoodItemProvider extends ChangeNotifier {
  FoodItemProvider() {
    fetchFoodItems();
    notifyListeners();
  }
  List<FoodItem> _fooditems = [];

  List<FoodItem> get fooditems {
    return [..._fooditems];
  }

  void addFoodItem(FoodItem fooditem) async {
    print(jsonEncode(fooditem));

    final response = await http.post(Uri.parse(target + '/fooditem/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(fooditem));
    print(response.body);
    if (response.statusCode == 201) {
      fooditem.item_id = json.decode(response.body)['item_id'];
      _fooditems.add(fooditem);
      notifyListeners();
    }
  }

  void deleteTodo(FoodItem fooditem) async {
    print('The value of the input is: ${fooditem.item_id}');
    final response =
        await http.delete(Uri.parse(target + '/fooditem/${fooditem.item_id}'));

    if (response.statusCode == 204) {
      _fooditems.remove(fooditem);
      notifyListeners();
    }
  }

  fetchFoodItems() async {
    const url = target + '/fooditem/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _fooditems =
          data.map<FoodItem>((json) => FoodItem.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class ItemQuantityProvider extends ChangeNotifier {
  ItemQuantityProvider() {
    fetchItemQuantitys();
    notifyListeners();
  }
  List<ItemQuantity> _itemquantitys = [];

  List<ItemQuantity> get itemquantitys {
    return [..._itemquantitys];
  }

  void addItemQuantity(ItemQuantity itemquantity) async {
    print(jsonEncode(itemquantity));

    final response = await http.post(Uri.parse(target + '/itemquantity/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(itemquantity));
    print(response.body);
    if (response.statusCode == 201) {
      itemquantity.id = json.decode(response.body)['id'];
      _itemquantitys.add(itemquantity);
      notifyListeners();
    }
  }

  void deleteTodo(ItemQuantity itemquantity) async {
    print('The value of the input is: ${itemquantity.id}');
    final response = await http
        .delete(Uri.parse(target + '/itemquantity/${itemquantity.id}'));

    if (response.statusCode == 204) {
      _itemquantitys.remove(itemquantity);
      notifyListeners();
    }
  }

  fetchItemQuantitys() async {
    const url = target + '/itemquantity/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _itemquantitys = data
          .map<ItemQuantity>((json) => ItemQuantity.fromJson(json))
          .toList();
      notifyListeners();
    }
  }
}

class InventoryProvider extends ChangeNotifier {
  InventoryProvider() {
    fetchTasksInventory();
    notifyListeners();
  }
  List<Inventory> _inventorys = [];

  List<Inventory> get inventorys {
    return [..._inventorys];
  }

  void deleteMealSchedule(Inventory inventory) async {
    // print('The value of the input is: ${hiker.hiker_id}');
    final response = await http
        .delete(Uri.parse(target + '/inventory/${inventory.inventory_id}/'));

    if (response.statusCode == 204) {
      _inventorys.remove(inventory);
      notifyListeners();
    }
  }

  void addInventory(Inventory inventory) async {
    print('called');
    print(inventory);
    print('called');
    print(jsonEncode(inventory));
    final response = await http.post(Uri.parse(target + '/inventory/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(inventory));

    if (response.statusCode == 201) {
      inventory.inventory_id = json.decode(response.body)['inventory_id'];
      _inventorys.add(inventory);
      notifyListeners();
    }
  }

  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse(target+'/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksInventory() async {
    const url = target + '/inventory/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _inventorys =
          data.map<Inventory>((json) => Inventory.fromJson(json)).toList();
      notifyListeners();
    }
  }
}

class HikerProvider with ChangeNotifier {
  HikerProvider() {
    fetchTasksHiker();
    notifyListeners();
  }
  List<Hiker> _hikers = [];

  List<Hiker> get hikers {
    return [..._hikers];
  }

  Hiker getHiker(dynamic? id) {
    int s = 0;
    for (int i = 0; i < _hikers.length; i++) {
      if (_hikers.elementAt(i).hiker_id == id) {
        s = i;
      }
    }
    return _hikers[s];
  }

  void deleteHiker(Hiker hiker) async {
    // print('The value of the input is: ${hiker.hiker_id}');
    final response =
        await http.delete(Uri.parse(target + '/hiker/${hiker.hiker_id}/'));

    if (response.statusCode == 204) {
      _hikers.remove(hiker);
      notifyListeners();
    }
  }

  void addHiker(Hiker hiker) async {
    print('called');
    print(hiker);
    print('called');
    print(jsonEncode(hiker));
    final response = await http.post(Uri.parse(target + '/hiker/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(hiker));

    if (response.statusCode == 201) {
      hiker.hiker_id = json.decode(response.body)['hiker_id'];
      _hikers.add(hiker);
      notifyListeners();
    }
  }

  // void deleteTodo(Item item) async {
  //   print('The value of the input is: ${item.item_id}');
  //   final response = await http
  //       .delete(Uri.parse(target+'/item/${item.item_id}'));

  //   if (response.statusCode == 204) {
  //     _items.remove(item);
  //     notifyListeners();
  //   }

  fetchTasksHiker() async {
    const url = target + '/hiker/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _hikers = data.map<Hiker>((json) => Hiker.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
