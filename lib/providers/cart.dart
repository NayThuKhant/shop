import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _products = {};

  Map<String, CartItem> get products => {..._products};

  int get productCount => _products.length;

  double get total {
    double total = 0.0;
    _products.forEach((key, product) {
      total += product.price * product.quantity;
    });
    return total;
  }

  void addProduct({
    required String productId,
    required double price,
    required String title,
  }) {
    if (_products.containsKey(productId)) {
      _products.update(
        productId,
        (value) => CartItem(
          id: value.id,
          title: value.title,
          quantity: value.quantity + 1,
          price: value.price,
        ),
      );
    } else {
      _products.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            price: price),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _products.remove(productId);
    notifyListeners();
  }

  void undoAddToCart(String productId) {
    if (_products.containsKey(productId)) {
      if (_products[productId]!.quantity > 1) {
        _products.update(
          productId,
          (value) => CartItem(
            id: value.id,
            title: value.title,
            quantity: value.quantity - 1,
            price: value.price,
          ),
        );
      } else {
        _products.remove(productId);
      }
      notifyListeners();
    }
    return;
  }

  void clear() {
    _products = {};
    notifyListeners();
  }
}
