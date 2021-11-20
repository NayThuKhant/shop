import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  favourites,
  all,
}

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _showOnlyFavourites = false;

  void _toggleFilter(filterOption) {
    setState(() {
      if (filterOption == FilterOptions.favourites) {
        _showOnlyFavourites = true;
      } else {
        _showOnlyFavourites = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            onSelected: _toggleFilter,
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.favourites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.all,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child!,
              color: Theme.of(context).colorScheme.secondary,
              value: cart.productCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ProductsGrid(showOnlyFavourites: _showOnlyFavourites),
    );
  }
}
