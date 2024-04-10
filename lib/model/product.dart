import 'package:isar/isar.dart';

part 'product.g.dart';

@Collection()
class Product {
  Product(this.name, this.description, this.quantity, this.price, this.photo,
      this.category);
  Id id = Isar.autoIncrement;
  late String name, description;
  late int quantity;
  late double price;
  late String photo;
  late String category;
}
