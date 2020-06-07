import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appdrawer.dart';
import '../widgets/user_product.dart';
import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static final routeName = "/user_screen";

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
          future: Provider.of<Products>(context, listen: false)
              .fetchAndSetProducts(true),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error == null) {
                return RefreshIndicator(
                  onRefresh: () => _refreshData(context),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Consumer<Products>(
                      builder: (ctx, userProduct, _) => ListView.builder(
                        itemCount: userProduct.items.length,
                        itemBuilder: (_, i) => UserProduct(
                            userProduct.items[i].id,
                            userProduct.items[i].title,
                            userProduct.items[i].imageUrl),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Text("An Error Occured"),
                );
              }
            }
          }),
    );
  }
}
