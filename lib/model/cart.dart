import 'package:botika/model/product.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  Cart();
  List<Product> products = [];
  double getTotal() {
    double total = 0.0;
    for (int i = 0; i < products.length; i++) {
      total += products[i].price;
    }
    return total;
  }

  void addProductToCart(Product product) {
    if (products.contains(product)) {
      products[products.indexOf(product)].price +=
          products[products.indexOf(product)].price;
    } else {
      products.add(product);
    }

    notifyListeners();
  }

  List<Product> getProductInCart() {
    return products;
  }

  void deleteFromCart(int index) {
    products.removeAt(index);
    notifyListeners();
  }
}
