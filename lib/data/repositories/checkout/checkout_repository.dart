import '../../../core/core.dart';

abstract class CheckoutRepository {
  Future<Result<bool>> finalizePurchase();
}
