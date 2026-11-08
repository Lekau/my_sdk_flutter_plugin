import 'package:flutter/foundation.dart';
import 'package:my_sdk_flutter_plugin/models/item_model.dart';

class Cart extends ChangeNotifier {
  final List<Item> _items = [];
  double? _priceOverride;

  List<Item> get items => List.unmodifiable(_items);

  double get subtotal =>
      _items.fold(0, (total, item) => total + item.price);

  double get total => _priceOverride ?? subtotal;

  void addItem(Item item) {

    _items.add(item);
    print('Item added: ${item.name}');
    notifyListeners();
  }

  void removeItem(Item item) {
    _items.remove(item);
    print('Item removed: ${item.name}');
    notifyListeners();
  }
  
  void applyDiscount(double discountAmount) {
    setPriceOverride(subtotal - discountAmount);
  }

  void clear() {
    _items.clear();
    print('Cart cleared');
    notifyListeners();
  }

  @override
  void dispose() {
    print('Cart disposed');
    super.dispose();
  }

  void setPriceOverride(double? price) {
    _priceOverride = price;
    notifyListeners();
  }
}