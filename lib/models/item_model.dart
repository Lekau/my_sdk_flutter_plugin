import 'package:flutter/material.dart';

class Item {
  final String name;
  final double price;
  final String description;
  final IconData icon;

  Item({required this.name, required this.price, required this.description, required this.icon});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      price: json['price'],
      description: json['description'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'icon': icon.codePoint,
    };
  }
}


