import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/trip.dart';
import '../models/item.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.post(Uri.parse('http://127.0.0.1:8000/item/'),
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
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/item/${item.item_id}'));

    if (response.statusCode == 204) {
      _items.remove(item);
      notifyListeners();
    }
  }

  fetchTasks() async {
    const url = 'http://127.0.0.1:8000/item/?format=json';
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

  void deleteTrip(Trip trip) async {
    print('The value of the input is: ${trip.trip_id}');
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/trip/${trip.trip_id}/'));

    if (response.statusCode == 204) {
      _trips.remove(trip);
      notifyListeners();
    }
  }

  void addTrip(Trip trip) async {
    print('called');
    print(trip);
    final response = await http.post(Uri.parse('http://127.0.0.1:8000/trip/'),
        headers: {"Content-Type": "application/json"}, body: json.encode(trip));

    if (response.statusCode == 201) {
      trip.trip_id = json.decode(response.body)['trip_id'];
      _trips.add(trip);
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

  fetchTasksTrip() async {
    const url = 'http://127.0.0.1:8000/trip/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _trips = data.map<Trip>((json) => Trip.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
