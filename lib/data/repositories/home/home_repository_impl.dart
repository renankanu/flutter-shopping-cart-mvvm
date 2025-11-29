import 'package:dio/dio.dart';

import '../../../core/core.dart';
import '../../../domain/models/product.dart';
import '../../dtos/product_dto.dart';
import 'home_repository.dart';

final class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  HomeRepositoryImpl({required this.dio});

  @override
  Future<Result<List<Product>>> getProducts() async {
    final response = await dio.get(AppConstants.products);
    try {
      return Result.ok(
        (response.data as List)
            .map(
              (e) => ProductDto.fromJson(e as Map<String, dynamic>).toDomain(),
            )
            .toList(),
      );
    } on DioException catch (error) {
      return Result.error(NetworkException.fromDioError(error));
    } catch (_) {
      return Result.error(Exception('Erro ao buscar produtos'));
    }
  }
}
