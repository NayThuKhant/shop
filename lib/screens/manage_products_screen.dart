import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/manage_product_item.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';

class ManageProductsScreen extends StatelessWidget {
  static const routeName = '/manage-products';
  const ManageProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: (builder, index) => ManageProductItem(
          product: products[index],
        ),
        itemCount: products.length,
      ),
    );
  }
}
