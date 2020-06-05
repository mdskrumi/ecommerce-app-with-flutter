import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
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
  bool _init = true;
  bool _isLoading = false;
  bool _isLoadingCartIcon = false;

  @override
  void didChangeDependencies() {
    if (_init) {
      setState(() {
        _isLoading = true;
        _isLoadingCartIcon = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<Cart>(context, listen: false).fetchAndSetData().then((_) {
        setState(() {
          _isLoadingCartIcon = false;
        });
      });
    }
    _init = false;
    super.didChangeDependencies();
  }

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
          _isLoadingCartIcon
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<Cart>(
                  builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.count.toString(),
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGridview(_isFavOnly),
    );
  }
}
