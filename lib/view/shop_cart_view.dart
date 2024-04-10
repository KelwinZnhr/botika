import 'package:botika/const.dart';
import 'package:botika/model/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShopCartView extends StatelessWidget {
  const ShopCartView({
    super.key,
    required this.controller,
    required this.cartProvider,
  });

  final ScrollController controller;
  final Cart cartProvider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.blue,
      width: MediaQuery.of(context).size.width / 2 - 200,
      height: MediaQuery.of(context).size.height - 70,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              controller: controller,
              itemCount: cartProvider.products.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    shape: const RoundedRectangleBorder(),
                    onTap: () => cartProvider.deleteFromCart(index),
                    title: Text(cartProvider.products[index].name),
                    trailing:
                        Text(cartProvider.products[index].price.toString()),
                  )
                      .animate()
                      .fadeIn(curve: Curves.easeOut)
                      .scale(begin: const Offset(0.5, 0.9)),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 2 - 200,
                color: lightColorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        'Ar ${cartProvider.getTotal().toString()}',
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
