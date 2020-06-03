import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  void selectedProduct(BuildContext context, String id) {
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    final scaffold = Scaffold.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GestureDetector(
        onTap: () => selectedProduct(context, product.id),
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: LayoutBuilder(
            builder: (ctx, constraints) => GridTileBar(
              backgroundColor: Colors.black87,
              leading: Container(
                width: constraints.maxWidth * 0.2,
                child: Consumer<Product>(
                  builder: (ctx, product, child) => IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () async {
                      try {
                        await product.toggleFavorite();
                      } catch (error) {
                        scaffold.showSnackBar(SnackBar(
                          content: Text('Facing Error'),
                        ));
                      }
                    },
                  ),
                ),
              ),
              title: Container(
                width: constraints.maxWidth * 0.6,
                child: SizedBox(
                  child: Text(
                    product.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              trailing: Container(
                width: constraints.maxWidth * 0.2,
                child: IconButton(
                  color: Theme.of(context).accentColor,
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () async {
                    try {
                      await cart.addItem(
                          product.id, product.title, product.price);
                      scaffold.hideCurrentSnackBar();
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text("New Item Added"),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: "UNDO",
                            onPressed: () {
                              cart.undoAddItem(product.id);
                            },
                          ),
                        ),
                      );
                    } catch (error) {
                      scaffold.showSnackBar(
                        SnackBar(
                          content: Text("Something went wrong!!!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
