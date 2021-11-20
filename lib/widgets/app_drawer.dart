import 'package:flutter/material.dart';

import '../screens/manage_products_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String routeName,
  ) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(routeName);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Shop'),
            automaticallyImplyLeading: false,
          ),
          buildDrawerItem(
            context,
            Icons.shop,
            'Shop',
            ProductsScreen.routeName,
          ),
          buildDrawerItem(
            context,
            Icons.shop,
            'Orders',
            OrdersScreen.routeName,
          ),
          buildDrawerItem(
            context,
            Icons.edit,
            'Manage Products',
            ManageProductsScreen.routeName,
          ),
        ],
      ),
    );
  }
}
