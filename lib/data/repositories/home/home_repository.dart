import '../../../domain/models/product.dart';

abstract class HomeRepository {
  Future<List<Product>> getProducts();
}
