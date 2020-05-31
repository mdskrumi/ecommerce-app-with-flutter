import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badge.dart';
import '../widgets/appdrawer.dart';
import '../providers/cart.dart';
import '../widgets/product_Grid.dart';
import '../screens/cart_screen.dart';

enum FilterItem {
  All,
  Favorite,
}

class ProductOverviewScreen extends StatefulWidget {
  static final routeName = '/Product-Overview-Screen';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isFavOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.menu),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text("All"),
                  value: FilterItem.All,
                ),
                PopupMenuItem(
                  child: Text("Favorites Only"),
                  value: FilterItem.Favorite,
                ),
              ];
            },
            onSelected: (val) {
              setState(() {
                if (val == FilterItem.All)
                  _isFavOnly = false;
                else
                  _isFavOnly = true;
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.Count.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: ProductGridview(_isFavOnly),
    );
  }
}
