import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(auth, userId) async {
    final url =
        "https://my-flutter-project-88b3e.firebaseio.com/userFavorites/$userId/$id.json?auth=$auth";
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      //print(response.body);
    } catch (error) {
      isFavorite = !isFavorite;
      print("The Error in toggleFavorite(): " + error.toString());
      notifyListeners();
      throw error;
    }
  }
}
