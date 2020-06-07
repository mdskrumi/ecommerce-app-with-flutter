import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../providers/order.dart';

class OrderItemLayout extends StatefulWidget {
  final OrderItem orderItem;

  OrderItemLayout(this.orderItem);

  @override
  _OrderItemLayoutState createState() => _OrderItemLayoutState();
}

class _OrderItemLayoutState extends State<OrderItemLayout> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "\$" + widget.orderItem.amount.toString(),
            ),
            subtitle: Text(
              DateFormat("dd mm yyyy hh:mm").format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(widget.orderItem.products.length * 20.0 + 100, 100),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: ListView.builder(
                itemCount: widget.orderItem.products.length,
                itemBuilder: (ctx, i) {
                  return Row(
                    children: <Widget>[
                      Text(widget.orderItem.products[i].title),
                      Spacer(),
                      Text(widget.orderItem.products[i].quantity.toString() + " X " + widget.orderItem.products[i].price.toString())
                    ],
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
