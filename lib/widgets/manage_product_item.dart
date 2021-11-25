import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../screens/create_product_screen.dart';

class ManageProductItem extends StatelessWidget {
  final Product product;

  const ManageProductItem({Key? key, required this.product}) : super(key: key);

  void _removeProduct(productId, context) {
    Provider.of<Products>(context, listen: false).removeProduct(productId);

    ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      const SnackBar(
        content: Text("Product removed!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              product.imageUrl,
            ),
          ),
          title: Text(product.title),
          trailing: FittedBox(
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        CreateProductScreen.routeName,
                        arguments: product.id);
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _removeProduct(product.id, context);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
