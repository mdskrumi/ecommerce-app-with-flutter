import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/order.dart';

class OrderBUtton extends StatefulWidget {
  @override
  _OrderBUttonState createState() => _OrderBUttonState();
}

class _OrderBUttonState extends State<OrderBUtton> {
  bool _isOrdering = false;
  bool _isValid = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orderData = Provider.of<Order>(context, listen: false);

    if (cart.count <= 0) {
      _isValid = false;
    } else {
      _isValid = true;
    }

    return FlatButton(
      disabledTextColor: Colors.grey,
      onPressed: !_isValid
          ? null
          : () async {
              setState(() {
                _isOrdering = true;
              });
              try {
                await orderData.addOrder(
                    cart.items.values.toList(), cart.totalAmount);
                await cart.clear();
                setState(() {
                  _isValid = false;
                });
              } catch (error) {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("Something went wrong!"),
                          content: Text("Please Try Again later"),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("Okay"),
                            )
                          ],
                        ));
              }
              setState(() {
                _isOrdering = false;
              });
            },
      child: _isOrdering
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Text(
              "ORDER NOW",
            ),
    );
  }
}
