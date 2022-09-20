class Item {
  // ignore: non_constant_identifier_names
  int? item_id;
  final String item_name;
  final double? item_weight;
  final int? item_hiker;
  final String? item_category;
  final String item_description;
  final bool isEssential;
  final bool isFavorite;

  Item(
      {required this.item_name,
      required this.item_weight,
      required this.isEssential,
      required this.isFavorite,
      required this.item_description,
      // ignore: non_constant_identifier_names
      this.item_id,
      this.item_hiker,
      this.item_category
      // required this.item_quantity,
      //
      // required this.item_description
      });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        item_id: json['item_id'],
        item_name: json['item_name'],
        item_weight: json['item_weight'],
        item_category: json['item_category'],
        isEssential: json['isEssential'],
        isFavorite: json['isFavorite'],
        item_description: json['item_description'],
        item_hiker: json['item_hiker']);
  }
  dynamic toJson() => {
        'item_id': item_id.toString(),
        'item_name': item_name,
        'item_weight': item_weight,
        'item_hiker': item_hiker,
        'item_category': item_category,
        'isEssential': isEssential,
        'isFavorite': isFavorite,
        'item_description': item_description
      };
}

class FoodItem extends Item {
  // ignore: non_constant_identifier_names
  final int calories;
  final int protein;
  final int sugar;

  FoodItem(
      {required String item_name,
      required double item_weight,
      required bool isEssential,
      required bool isFavorite,
      required String item_description,
      required this.calories,
      required this.protein,
      required this.sugar,
      // ignore: non_constant_identifier_names
      int? item_id,
      int? item_hiker,
      String? item_category
      // required this.item_quantity,
      //
      // required this.item_description
      })
      : super(
            isEssential: isEssential,
            isFavorite: isFavorite,
            item_id: item_id,
            item_name: item_name,
            item_weight: item_weight,
            item_description: item_description,
            item_hiker: item_hiker,
            item_category: item_category);

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
        item_id: json['item_id'] as int?,
        item_name: json['item_name'],
        item_weight: json['item_weight'],
        item_category: json['item_category'],
        isEssential: json['isEssential'],
        isFavorite: json['isFavorite'],
        item_description: json['item_description'],
        item_hiker: json['item_hiker'],
        calories: json['calories'],
        protein: json['protein'],
        sugar: json['sugar']);
  }
  dynamic toJson() => {
        'item_id': item_id.toString(),
        'item_name': item_name,
        'item_weight': item_weight,
        'item_hiker': item_hiker,
        'item_category': item_category,
        'isEssential': isEssential,
        'isFavorite': isFavorite,
        'item_description': item_description,
        'calories': calories,
        'protein': protein,
        'sugar': sugar
      };
}

class ItemQuantity {
  // ignore: non_constant_identifier_names
  int? id;
  final int item_quantity;
  final bool isMultiple;
  final String item_note;
  final int inventory;
  final int item;
  final int? meal;

  ItemQuantity({
    required this.item_quantity,
    required this.isMultiple,
    required this.item_note,
    required this.inventory,
    required this.item,
    // nullable
    this.meal,
    this.id,
  });

  factory ItemQuantity.fromJson(Map<String, dynamic> json) {
    return ItemQuantity(
        id: json['id'],
        item_quantity: json['item_quantity'],
        inventory: json['inventory'],
        isMultiple: json['isMultiple'],
        item_note: json['item_note'],
        item: json['item'],
        meal: json['meal']);
  }
  dynamic toJson() => {
        'id': id,
        'item_quantity': item_quantity,
        'inventory': inventory,
        'isMultiple': isMultiple,
        'item_note': item_note,
        'item': item,
        'meal': meal,
      };
}

class Inventory {
  // ignore: non_constant_identifier_names
  int? inventory_id;
  final String? inventory_name;
  final List<dynamic>? inventory_items;
  final int? inventory_hiker;
  final int? inventory_trip;
  final double? inventory_weight;
  final double? carried_weight_percentage;

  Inventory({
    required this.inventory_name,
    this.inventory_items,
    required this.inventory_hiker,
    required this.inventory_trip,
    required this.inventory_weight,
    this.carried_weight_percentage,
    // ignore: non_constant_identifier_names
    this.inventory_id,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
        inventory_id: json['inventory_id'],
        inventory_name: json['inventory_name'],
        inventory_items: json['inventory_items'],
        inventory_hiker: json['inventory_hiker'],
        inventory_trip: json['inventory_trip'],
        inventory_weight: json['inventory_weight'],
        carried_weight_percentage: json['carried_weight_percentage']);
  }
  dynamic toJson() => {
        'inventory_id': inventory_id,
        'inventory_name': inventory_name,
        'inventory_items': inventory_items,
        'inventory_hiker': inventory_hiker,
        'inventory_trip': inventory_trip,
      };
}
