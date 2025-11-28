import 'package:dio/dio.dart';

import '../../../core/app_constants.dart';
import '../../../domain/models/product.dart';
import '../../dtos/product_dto.dart';
import 'home_repository.dart';

final class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  HomeRepositoryImpl({required this.dio});

  @override
  Future<List<Product>> getProducts() async {
    final response = await dio.get(AppConstants.products);
    return (response.data as List)
        .map((e) => ProductDto.fromJson(e as Map<String, dynamic>).toDomain())
        .toList();
  }
}
