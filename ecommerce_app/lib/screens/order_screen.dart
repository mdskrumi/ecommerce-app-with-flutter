import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/appdrawer.dart';
import '../providers/order.dart';
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static final routeName = "/Order_Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<Order>(context).fetchAndSetOrderData(),
          builder: (ctx, dataScapshot) {
            if (dataScapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataScapshot.error != null) {
                /* ------ ERROR-------*/
                return Center(
                  child: Text("No Order is Issued"),
                );
              } else {
                return Consumer<Order>(
                  builder: (ctx, orderData, ch) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) =>
                        OrderItemLayout(orderData.orders[i]),
                  ),
                );
              }
            }
          }),
    );
  }
}
