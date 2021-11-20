import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  void addToCart(Cart cart, Product product, BuildContext context) {
    cart.addProduct(
      productId: product.id,
      price: product.price,
      title: product.title,
    );

    ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);
    scaffoldMessengerState.hideCurrentSnackBar();
    scaffoldMessengerState.showSnackBar(
      SnackBar(
        content: const Text(
          'Added to the cart!',
        ),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            cart.undoAddToCart(product.id);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductScreen.routeName, arguments: product.id);
        },
        child: GridTile(
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return SizedBox(
                height: 250,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 50,
                      ),
                      Text('Couldn\'t load the image!')
                    ],
                  ),
                ),
              );
            },
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (_, product, child) => IconButton(
                icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () {
                  product.toggleFavourite();
                },
              ),
            ),
            backgroundColor: Colors.black45,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => addToCart(cart, product, context),
            ),
          ),
        ),
      ),
    );
  }
}
