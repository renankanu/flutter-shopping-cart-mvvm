import '../../../core/core.dart';
import '../../../domain/models/product.dart';
import 'cart_repository.dart';

final class CartRepositoryImpl implements CartRepository {
  @override
  Future<Result<void>> removeItem(Product product) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return Result.error(
      CartException(message: 'Erro ao remover item. Tente novamente.'),
    );
  }
}
