import 'package:dio/dio.dart';

import '../../../core/core.dart';
import 'checkout_repository.dart';

final class CheckoutRepositoryImpl implements CheckoutRepository {
  final Dio dio;

  CheckoutRepositoryImpl({required this.dio});

  @override
  Future<Result<bool>> finalizePurchase() async {
    try {
      await Future.delayed(const Duration(milliseconds: 600));
      return Result.ok(true);
    } on DioException catch (error) {
      return Result.error(NetworkException.fromDioError(error));
    } catch (_) {
      return Result.error(Exception('Erro ao finalizar compra'));
    }
  }
}
