class Item {
  int? item_id;
  final String item_name;
  final double? item_weight;
  final int? item_hiker;
  // final String item_category;
  // final int item_quantity;
  // final String item_description;

  Item({
    required this.item_name,
    required this.item_weight,
    required this.item_hiker,
    this.item_id,
    // required this.item_quantity,
    //
    // required this.item_description
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
        item_id: json['item_id'],
        item_name: json['item_name'],
        item_weight: json['item_weight'],
        // item_category: json['item_category'],
        // item_quantity: json['item_quantity'],
        // item_description: json['item_description'],
        item_hiker: json['item_hiker']);
  }
  dynamic toJson() => {
        'item_id': item_id,
        'item_name': item_name,
        'item_weight': item_weight,
        'item_hiker': item_hiker,
      };
}
