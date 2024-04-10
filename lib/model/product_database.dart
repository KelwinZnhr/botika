import 'package:botika/model/product.dart';
import 'package:flutter/widgets.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ProductDatabase extends ChangeNotifier {
  static late Isar isar;
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([ProductSchema], directory: dir.path);
  }

  final List<Product> currentProducts = [];

  Future<void> addProduct(String name, String description, int quantity,
      double price, String photo, String category) async {
    final newProduct =
        Product(name, description, quantity, price, photo, category);
    await isar.writeTxn(() => isar.products.put(newProduct));

    fetchProducts();
  }

  Future<void> fetchProducts() async {
    List<Product> fetchedProducts = await isar.products.where().findAll();
    currentProducts.clear();
    currentProducts.addAll(fetchedProducts);
    notifyListeners();
  }

  Future<void> updateProduct(int id, String name, String description,
      int quantity, double price, String photo) async {
    final existingProduct = await isar.products.get(id);
    if (existingProduct != null) {
      existingProduct.name = name;
      existingProduct.description = description;
      existingProduct.quantity = quantity;
      existingProduct.price = price;
      existingProduct.photo = photo;
      existingProduct.description;
      await isar.writeTxn(() => isar.products.put(existingProduct));
      await fetchProducts();
    }
  }

  Future<void> takeFromProduct(int id, int number) async {
    final existingProduct = await isar.products.get(id);
    if (existingProduct != null) {
      existingProduct.quantity = existingProduct.quantity - number;

      await isar.writeTxn(() => isar.products.put(existingProduct));
      await fetchProducts();
    }
  }

  Future<void> deleteProduct(int id) async {
    await isar.writeTxn(() => isar.products.delete(id));
    await fetchProducts();
  }

  Future<void> searchProduct(String search) async {
    List<Product> searchedProducts =
        await isar.products.filter().nameContains(search).findAll();
    currentProducts.clear();
    currentProducts.addAll(searchedProducts);
    notifyListeners();
  }
}
