import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem({
    Key? key,
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  Future<bool> confirmRemove(BuildContext context) async {
    bool confirm = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Are you sure?'),
        content:
            const Text('Do you want to remove this product from the cart?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
              confirm = true;
            },
            child: const Text(
              'YES',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(false);
              confirm = false;
            },
            child: const Text(
              'NO',
            ),
          ),
        ],
      ),
    );
    return confirm;
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeProduct(productId);
      },
      confirmDismiss: (DismissDirection direction) {
        return confirmRemove(context);
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 10),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    price.toString(),
                  ),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('x $quantity'),
            trailing:
                Text('Total : \$${(price * quantity).toStringAsFixed(2)}'),
          ),
        ),
      ),
    );
  }
}
