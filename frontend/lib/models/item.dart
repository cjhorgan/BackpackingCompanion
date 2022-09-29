class Item {
  // ignore: non_constant_identifier_names
  int? item_id;
  final String item_name;
  final double? item_weight;
  final dynamic item_hiker;
  final String item_category;
  final String item_description;
  final bool isEssential;
  final bool isFavorite;

  Item(
      {required this.item_name,
      required this.item_weight,
      required this.isEssential,
      required this.isFavorite,
      required this.item_description,
      required this.item_category,
      // ignore: non_constant_identifier_names
      this.item_id,
      this.item_hiker});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        item_id: json['item_id'],
        item_name: json['item_name'],
        item_weight: json['item_weight'],
        item_category: json['item_category'],
        isEssential: json['isEssential'],
        isFavorite: json['isFavorite'],
        item_description: json['item_description'],
        item_hiker: json['item_hiker'] ?? 'null');
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

  FoodItem({
    required String item_name,
    required double item_weight,
    required bool isEssential,
    required bool isFavorite,
    required String item_description,
    required this.calories,
    required this.protein,
    required this.sugar,
    required String item_category,
    // ignore: non_constant_identifier_names
    int? item_id,
    int? item_hiker,
    // required this.item_quantity,
    //
    // required this.item_description
  }) : super(
          isEssential: isEssential,
          isFavorite: isFavorite,
          item_id: item_id,
          item_name: item_name,
          item_weight: item_weight,
          item_description: item_description,
          item_hiker: item_hiker,
          item_category: item_category,
        );

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
        item_id: json['item_id'],
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
        id: json['id'] as int,
        item_quantity: json['item_quantity'] as int,
        inventory: json['inventory'] as int,
        isMultiple: json['isMultiple'] as bool,
        item_note: json['item_note'] as String,
        item: json['item'] as int,
        meal: json['meal'] as int);
  }
  dynamic toJson() => {
        'item_quantity': item_quantity,
        'isMultiple': isMultiple,
        'item_note': item_note,
        'item': item,
        'meal': meal,
        'inventory': inventory,
      };
}

class Inventory {
  // ignore: non_constant_identifier_names
  int? inventory_id;
  final String inventory_name;
  final List<dynamic>? inventory_items;
  final int inventory_hiker;
  final int inventory_trip;
  final double? inventory_weight;
  final double? carried_weight_percentage;

  Inventory({
    required this.inventory_name,
    required this.inventory_hiker,
    required this.inventory_trip,
    this.inventory_weight,
    // ignore: non_constant_identifier_names
    this.carried_weight_percentage,
    this.inventory_items,
    this.inventory_id,
  });

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
        inventory_id: json['inventory_id'],
        inventory_name: json['inventory_name'],
        inventory_items: json['inventory_items'] ?? 'null',
        inventory_hiker: json['inventory_hiker'] ?? 2,
        inventory_trip: json['inventory_trip'],
        inventory_weight: json['inventory_weight'] ?? 0.0,
        carried_weight_percentage: json['carried_weight_percentage'] ?? 0.0);
  }
  dynamic toJson() => {
        'inventory_name': inventory_name,
        'inventory_hiker': inventory_hiker,
        'inventory_trip': inventory_trip,
      };
}
