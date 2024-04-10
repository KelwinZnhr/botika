import 'package:botika/const.dart';
import 'package:botika/model/cart.dart';
import 'package:botika/model/product.dart';
import 'package:botika/model/product_database.dart';
import 'package:botika/view/add_product_view.dart';
import 'package:botika/view/product_view.dart';
import 'package:botika/view/shop_cart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProductDatabase.initialize();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductDatabase>(
          create: (context) => ProductDatabase()),
      ChangeNotifierProvider<Cart>(create: (context) => Cart())
    ],
    child: const MyApp(),
  ));
}

ThemeMode defaultTheme = ThemeMode.dark;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: defaultTheme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void readProduct() {
    context.read<ProductDatabase>().fetchProducts();
  }

  void deleteProduct(int id) {
    context.read<ProductDatabase>().deleteProduct(id);
  }

  void takeFromProduct(int id, int number) {
    context.read<ProductDatabase>().takeFromProduct(id, number);
  }

  @override
  void initState() {
    //?fetching existing products
    readProduct();
    super.initState();
    // context.read<ProductDatabase>().addProduct(
    //     "biscuit", "très bon ", 15, 1000, 'sadfhjadfdajhf', 'alimentation');
    // context.read<ProductDatabase>().addProduct(
    //     "Stylo", "Pour ecrire", 15, 20, 'sadfhjadfdajhf', 'generique');
  }

  int selectedDestination = 0;
  bool search = false;
  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final TextEditingController textController = TextEditingController();

    NavigationRailLabelType labelType = NavigationRailLabelType.all;
    double groupAlignment = -1.0;
    final productDatabase = context.watch<ProductDatabase>();
    final cartProvider = context.watch<Cart>();
    List<Product> dataInCart = cartProvider.getProductInCart();
    List<Product> currentProducts = productDatabase.currentProducts;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 70,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Botika',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: logoColor,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: TextField(
                        onSubmitted: (value) async {
                          await context
                              .read<ProductDatabase>()
                              .searchProduct(textController.text);
                          setState(() {
                            search = true;
                          });
                        },
                        controller: textController,
                        decoration: const InputDecoration(
                          hintText: "Search for a product",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          await context
                              .read<ProductDatabase>()
                              .searchProduct(textController.text);
                          setState(() {
                            search = true;
                          });
                        },
                        icon: const Icon(Icons.search)),
                    search
                        ? IconButton(
                            onPressed: () async {
                              await context
                                  .read<ProductDatabase>()
                                  .fetchProducts();
                              setState(() {
                                search = false;
                              });
                            },
                            icon: const Icon(Icons.delete))
                        : const SizedBox()
                  ],
                )
              ],
            ),
          ),
          Row(
            children: [
              Row(
                children: [
                  Container(
                    color: Colors.teal,
                    width: 100,
                    height: MediaQuery.of(context).size.height - 70,
                    child: NavigationRail(
                      //backgroundColor: const Color.fromARGB(255, 225, 245, 233),
                      selectedIndex: selectedDestination,
                      groupAlignment: groupAlignment,
                      onDestinationSelected: (int i) {
                        setState(() {
                          selectedDestination = i;
                        });
                      },
                      labelType: labelType,
                      leading: FloatingActionButton(
                        elevation: 0,
                        onPressed: () {},
                        child: const Icon(Icons.storefront_rounded),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          // Add your onPressed code here!
                        },
                        icon: const Icon(Icons.more_horiz_rounded),
                      ),
                      destinations: const <NavigationRailDestination>[
                        NavigationRailDestination(
                          icon: Icon(Icons.store_outlined),
                          selectedIcon: Icon(Icons.store),
                          label: Text('Add Product'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.money_outlined),
                          selectedIcon: Icon(Icons.book),
                          label: Text('Second'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.star_border),
                          selectedIcon: Icon(Icons.star),
                          label: Text('Third'),
                        ),
                      ],
                    ),
                  ),
                  selectedDestination == 0
                      ? ProductView(currentProducts: currentProducts)
                      : const AddProductView(),
                ],
              ),
              dataInCart.isNotEmpty
                  ? ShopCartView(
                      controller: controller, cartProvider: cartProvider)
                  : const Center(
                      child: Text(
                      "No Item in cart.",
                      textAlign: TextAlign.center,
                    ))
            ],
          )
        ],
      ),
    );
  }
}
