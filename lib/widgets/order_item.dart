import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as order_provider;

class OrderItem extends StatefulWidget {
  final order_provider.OrderItem order;
  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '\$${widget.order.amount}',
            ),
            subtitle: Text(
              DateFormat('dd/MM/yy hh:mm').format(widget.order.createdAt),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, index) => Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      widget.order.products[index].title,
                    ),
                    Text(
                      '\$${widget.order.products[index].price} x ${widget.order.products[index].quantity}',
                    ),
                  ],
                ),
              ),
              itemCount: widget.order.products.length,
            ),
        ],
      ),
    );
  }
}
