import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';

class ProductDetailScreen extends StatelessWidget {
  static final routeName = '/Product-Detail-Screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .5,
                    child: ClipOval(
                      child: Hero(
                          tag: loadedProduct.id,
                          child: FadeInImage(
                            placeholder: AssetImage(
                              "assets/images/product_placeholder.png",
                            ),
                            image: NetworkImage(loadedProduct.imageUrl),
                          )),
                      key: ValueKey(loadedProduct.id),
                    ),
                  ),
                  Text(
                    loadedProduct.description,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Cost: \$" + loadedProduct.price.toString(),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).accentColor,
                      size: 30,
                    ),
                    onPressed: () {
                      cart.addItem(
                          productId, loadedProduct.title, loadedProduct.price);
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}
