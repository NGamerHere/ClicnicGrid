class InventoryItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String type;
  final double weight;
  final double volume;
  final DateTime expiresOn;
  final DateTime addedOn;
  final double itemsPerStack;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.type,
    required this.weight,
    required this.volume,
    required this.expiresOn,
    required this.addedOn,
    required this.itemsPerStack,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      type: json['type'],
      weight: (json['weight'] as num).toDouble(),
      volume: (json['volume'] as num).toDouble(),
      expiresOn: DateTime.parse(json['expiresOn']),
      addedOn: DateTime.parse(json['addedOn']),
      itemsPerStack: (json['itemsPerStack'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'type': type,
      'weight': weight,
      'volume': volume,
      'expiresOn': expiresOn.toIso8601String(),
      'addedOn': addedOn.toIso8601String(),
      'itemsPerStack': itemsPerStack,
    };
  }
}