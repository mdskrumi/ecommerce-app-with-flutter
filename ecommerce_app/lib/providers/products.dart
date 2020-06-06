import 'dart:convert';

import 'package:ecommerce_app/models/htttp_Exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class Products with ChangeNotifier {
  String _auth;
  String _userId;
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  void setAuth(auth, userId, items) {
    this._auth = auth;
    this._items = _items;
    this._userId = userId;
  }

  List<Product> get items {
    return _items;
  }

  List<Product> get favItems {
    return items.where((test) => test.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((p) => p.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    var url =
        'https://my-flutter-project-88b3e.firebaseio.com/products.json?auth=$_auth&orderBy="creatorId"&equalTo="$_userId"';
    try {
      final response = await http.get(url);
      final receivedData = json.decode(response.body) as Map<String, dynamic>;

      if (receivedData == null) {
        return;
      }
      print(receivedData);

      url =
          "https://my-flutter-project-88b3e.firebaseio.com/userFavorites/$_userId.json?auth=$_auth";
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      List<Product> fetchedProducts = [];
      receivedData.forEach((productId, productData) {
        fetchedProducts.add(
          Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            imageUrl: productData['imageUrl'],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
          ),
        );
      });
      _items = fetchedProducts;
      notifyListeners();
    } catch (error) {
      print("The Error: " + error.toString());
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://my-flutter-project-88b3e.firebaseio.com/products.json?auth=$_auth";
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'creatorId': _userId,
          },
        ),
      );
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print("Error is: " + error.toString());
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final id = product.id;
    final url =
        "https://my-flutter-project-88b3e.firebaseio.com/products/$id.json?auth=$_auth";

    try {
      await http.patch(url,
          body: json.encode({
            'title': product.title,
            "description": product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
    } catch (error) {
      print("The Error in UpdateProduct Function: " + error.toString());
      throw error;
    }

    final index = _items.indexWhere((element) => element.id == product.id);
    _items[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(id) async {
    final url =
        "https://my-flutter-project-88b3e.firebaseio.com/products/$id.json?auth=$_auth";
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete the item");
    }
    existingProduct = null;
  }
}
