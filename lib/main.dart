import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/manage_products_screen.dart';
import 'package:shop/screens/orders_screen.dart';

import './providers/products.dart';
import './screens/product_screen.dart';
import './screens/products_screen.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../screens/cart_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop',
        theme: ThemeData(
          fontFamily: "Lato",
          colorScheme:
              ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
            secondary: Colors.deepOrange,
          ),
        ),
        initialRoute: ProductsScreen.routeName,
        routes: {
          ProductsScreen.routeName: (_) => const ProductsScreen(),
          ProductScreen.routeName: (_) => const ProductScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          OrdersScreen.routeName: (_) => const OrdersScreen(),
          ManageProductsScreen.routeName: (_) => const ManageProductsScreen(),
        },
      ),
    );
  }
}
