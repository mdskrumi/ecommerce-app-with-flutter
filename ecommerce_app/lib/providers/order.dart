import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.dateTime, this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return _orders;
  }

  Future<void> fetchAndSetOrderData() async {
    final url = "https://my-flutter-project-88b3e.firebaseio.com/orders.json";

    try {
      final response = await http.get(url);

      final fetchedData = json.decode(response.body) as Map<String, dynamic>;

      List<OrderItem> loadedItems = [];

      fetchedData.forEach(
        (orderId, orderData) {
          List<CartItem> cartItems = [];
          for (dynamic cartItem in orderData['cartItem']) {
            var item = CartItem(
                id: cartItem['id'],
                title: cartItem['title'],
                price: cartItem['price'],
                quantity: cartItem['quantity']);
            cartItems.add(item);
          }

          loadedItems.add(
            OrderItem(
              id: orderId,
              products: cartItems,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['datetime']),
            ),
          );
        },
      );
      _orders = loadedItems;
    } catch (error) {
      print("Fetching Order data Error" + error.toString());
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = "https://my-flutter-project-88b3e.firebaseio.com/orders.json";

    final datetime = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'datetime': datetime.toIso8601String(),
          'cartItem': products
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'price': e.price,
                    'quantity': e.quantity,
                  })
              .toList(),
        }),
      );
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: products,
            dateTime: datetime,
          ));
    } catch (error) {
      print("The Error in function Add Order: " + error.toString());
      throw error;
    }
  }
}
