import '../../../core/exceptions/cart_exception.dart';
import '../../../domain/models/product.dart';
import 'cart_repository.dart';

final class CartRepositoryImpl implements CartRepository {
  @override
  Future<void> removeItem(Product product) async {
    await Future.delayed(const Duration(milliseconds: 600));

    throw CartException(
      message: 'Erro ao remover item. Tente novamente.',
    );
  }
}

