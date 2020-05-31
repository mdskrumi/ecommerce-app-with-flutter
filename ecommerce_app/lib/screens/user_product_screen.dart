import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appdrawer.dart';
import '../widgets/user_product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static final routeName = "/user_screen";

  @override
  Widget build(BuildContext context) {
    final userProduct = Provider.of<Products>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Product"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: userProduct.length,
        itemBuilder: (_, i) =>
            UserProduct(userProduct[i].id, userProduct[i].title, userProduct[i].imageUrl),
      ),
    );
  }
}
