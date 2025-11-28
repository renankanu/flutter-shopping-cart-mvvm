import 'package:dio/dio.dart';
import 'package:shopping_cart/data/repositories/checkout/checkout_repository.dart';

final class CheckoutRepositoryImpl implements CheckoutRepository {
  final Dio dio;

  CheckoutRepositoryImpl({required this.dio});

  @override
  Future<bool> finalizePurchase() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return true;
  }
}
