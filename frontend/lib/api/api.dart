import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/item.dart';
import 'package:http/http.dart' as http;

class ItemProvider with ChangeNotifier {
  ItemProvider() {
    fetchTasks();
  }
  List<Item> _items = [];

  List<Item> get items {
    return [..._items];
  }

  void addItem(Item item) async {
    final response = await http.post(Uri.parse('http://127.0.0.1:8000/items/'),
        headers: {"Content-Type": "application/json"}, body: json.encode(item));
    if (response.statusCode == 201) {
      item.item_id = json.decode(response.body)['item_id'];
      _items.add(item);
      notifyListeners();
    }
  }

  void deleteTodo(Item item) async {
    final response = await http
        .delete(Uri.parse('http://127.0.0.1:8000/items/${item.item_id}/'));
    if (response.statusCode == 204) {
      items.remove(item);
      notifyListeners();
    }
  }

  fetchTasks() async {
    const url = 'http://127.0.0.1:8000/items/?format=json';
    // ignore: unused_local_variable
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body) as List;
      _items = data.map<Item>((json) => Item.fromJson(json)).toList();
      notifyListeners();
    }
  }
}
