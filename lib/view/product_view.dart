import 'package:botika/const.dart';
import 'package:botika/model/cart.dart';
import 'package:botika/model/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  const ProductView({
    super.key,
    required this.currentProducts,
  });

  final List<Product> currentProducts;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //color: Colors.teal,
      width: MediaQuery.of(context).size.width / 2 + 100,
      height: MediaQuery.of(context).size.height - 70,
      child: currentProducts.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                  itemCount: currentProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (context, index) {
                    return Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_basket_rounded,
                                color: logoColor,
                                size: 80,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 8.0,
                                  left: 8.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentProducts[index].name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      currentProducts[index].description,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ar${currentProducts[index].price.toString()}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        context.read<Cart>().addProductToCart(
                                              currentProducts[index],
                                            );
                                      },
                                      icon: const Icon(
                                          Icons.add_shopping_cart_outlined),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }),
            )
          : const SizedBox(child: Text("No data")),
    );
  }
}
