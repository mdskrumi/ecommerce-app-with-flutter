import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appdrawer.dart';
import '../providers/order.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {

  static final routeName = "/Order_Screen";

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItemLayout(orderData.orders[i]),
      ),
    );
  }
}
