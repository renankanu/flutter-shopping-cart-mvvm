import '../../../domain/models/product.dart';

abstract class CartRepository {
  Future<void> removeItem(Product product);
}

