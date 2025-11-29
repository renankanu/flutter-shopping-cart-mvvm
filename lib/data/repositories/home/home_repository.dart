import '../../../core/core.dart';
import '../../../domain/models/product.dart';

abstract class HomeRepository {
  Future<Result<List<Product>>> getProducts();
}
