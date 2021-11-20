import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (BuildContext context, index) {
                var cartItem = cart.products.values.toList()[index];
                var productId = cart.products.keys.toList()[index];
                return CartItem(
                  id: cartItem.id,
                  productId: productId,
                  title: cartItem.title,
                  quantity: cartItem.quantity,
                  price: cartItem.price,
                );
              },
              itemCount: cart.productCount,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total : \$${cart.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.products.values.toList(),
                        cart.total,
                      );
                      cart.clear();
                    },
                    child: const Text('Order Now'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
