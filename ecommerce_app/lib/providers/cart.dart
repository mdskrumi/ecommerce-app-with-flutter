import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  int get Count {
    int len = 0;
    _items.forEach((k, v) => len += v.quantity);
    return len;
  }

  double get totalAmount {
    double ta = 0;
    _items.forEach((k, v) => ta += (v.quantity * v.price));
    return ta;
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (item) => CartItem(
          id: item.id,
          title: item.title,
          price: item.price,
          quantity: item.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void undoAddItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity > 1) {
        _items.update(
          productId,
          (currentItem) => CartItem(
              id: currentItem.id,
              title: currentItem.title,
              price: currentItem.price,
              quantity: currentItem.quantity - 1),
        );
      } else {
        _items.remove(productId);
      }
    }
    notifyListeners();
  }

  void deleteItem(productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
