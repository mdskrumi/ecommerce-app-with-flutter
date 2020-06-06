import 'dart:convert';

import 'package:ecommerce_app/models/htttp_Exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  String _auth;

  void setAuth(auth, items){
    this._auth = auth;
    this._items = items;
  }

  Map<String, CartItem> get items {
    return _items;
  }

  Future<void> fetchAndSetData() async {
    final url = "https://my-flutter-project-88b3e.firebaseio.com/carts.json?auth=$_auth";

    try {
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      Map<String, CartItem> loadedData = {};
      fetchedData.forEach((productId, itemInCart) {
        itemInCart.forEach((cartId, cartItem) {
          loadedData.putIfAbsent(
              productId,
              () => CartItem(
                    id: cartId,
                    title: cartItem['title'],
                    price: cartItem['price'],
                    quantity: cartItem['quantity'],
                  ));
        });
      });

      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  int get count {
    int len = 0;
    _items.forEach((k, v) => len += v.quantity);
    return len;
  }

  double get totalAmount {
    double ta = 0;
    _items.forEach((k, v) => ta += (v.quantity * v.price));
    return ta;
  }

  Future<void> addItem(String productId, String title, double price) async {
    var url =
        "https://my-flutter-project-88b3e.firebaseio.com/carts/$productId.json?auth=$_auth";

    if (_items.containsKey(productId)) {
      CartItem item = _items[productId];
      String itemId = item.id;
      var url =
          "https://my-flutter-project-88b3e.firebaseio.com/carts/$productId/$itemId.json?auth=$_auth";
      try {
        await http.patch(url,
            body: json.encode({
              'title': title,
              'price': price,
              'quantity': item.quantity + 1,
            }));
        _items.update(
          productId,
          (item) => CartItem(
            id: item.id,
            title: item.title,
            price: item.price,
            quantity: item.quantity + 1,
          ),
        );
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      try {
        final response = await http.post(url,
            body: json.encode({
              'title': title,
              'price': price,
              'quantity': 1,
            }));
        _items.putIfAbsent(
          productId,
          () => CartItem(
            id: json.decode(response.body)['name'],
            title: title,
            price: price,
            quantity: 1,
          ),
        );
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future undoAddItem(String productId) async {
    if (_items.containsKey(productId)) {
      if (_items[productId].quantity > 1) {
        final itemId = _items[productId].id;
        var url =
            "https://my-flutter-project-88b3e.firebaseio.com/carts/$productId/$itemId.json?auth=$_auth";
        try {
          await http.patch(url,
              body: json.encode({
                'quantity': _items[productId].quantity - 1,
              }));
          _items.update(
            productId,
            (item) => CartItem(
              id: item.id,
              title: item.title,
              price: item.price,
              quantity: item.quantity - 1,
            ),
          );
          notifyListeners();
        } catch (error) {
          throw error;
        }
      } else {
        deleteItem(productId);
      }
    }
  }

  Future<void> deleteItem(productId) async {
    var url =
        "https://my-flutter-project-88b3e.firebaseio.com/carts/$productId.json?auth=$_auth";

    final existingItem = _items[productId];
    _items.remove(productId);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.addAll({productId: existingItem});
      notifyListeners();
      throw HttpException("Failed");
    }
  }

  Future<void> clear() async {
    final url =
        "https://my-flutter-project-88b3e.firebaseio.com/carts.json?auth=$_auth";

    final response = await http.delete(url);
    if(response.statusCode>=400){
      throw HttpException("Something Went Wrong!!!");
    }
    _items.clear();
    notifyListeners();
  }
}
