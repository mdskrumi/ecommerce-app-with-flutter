import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../widgets/order_button.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orderData = Provider.of<Order>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total:",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: FittedBox(
                      child: Text(
                        "\$${cart.totalAmount}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderBUtton(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) => CartItemLayout(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}
