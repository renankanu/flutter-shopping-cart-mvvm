import '../../../core/core.dart';
import '../../../domain/models/product.dart';

abstract class CartRepository {
  Future<Result<void>> removeItem(Product product);
}
