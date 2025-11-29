import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_cart/core/utils/result.dart';
import 'package:shopping_cart/data/repositories/home/home_repository.dart';
import 'package:shopping_cart/domain/models/product.dart';
import 'package:shopping_cart/domain/models/rating.dart';
import 'package:shopping_cart/viewmodels/home/home_viewmodel.dart';

import 'home_viewmodel_test.mocks.dart';

@GenerateMocks([HomeRepository])
void main() {
  late HomeViewmodel viewModel;
  late MockHomeRepository mockRepository;

  setUpAll(() {
    provideDummy<Result<List<Product>>>(Result.ok([]));
  });

  setUp(() {
    mockRepository = MockHomeRepository();
    viewModel = HomeViewmodel(homeRepository: mockRepository);
  });

  group('HomeViewmodel', () {
    group('Testes iniciais', () {
      test('deve ter uma lista de produtos vazia inicialmente', () {
        expect(viewModel.products, isEmpty);
      });

      test('deve ter isLoading como false inicialmente', () {
        expect(viewModel.isLoading, false);
      });

      test('deve ter errorMessage como null inicialmente', () {
        expect(viewModel.errorMessage, null);
      });
    });

    group('Testes de getProducts', () {
      final mockProducts = [
        Product(
          id: 1,
          title: 'Product 1',
          price: 10.0,
          description: 'Description 1',
          category: 'Category 1',
          image: 'image1.jpg',
          rating: Rating(rate: 4.5, count: 100),
        ),
        Product(
          id: 2,
          title: 'Product 2',
          price: 20.0,
          description: 'Description 2',
          category: 'Category 2',
          image: 'image2.jpg',
          rating: Rating(rate: 4.0, count: 50),
        ),
      ];

      test(
        'deve definir isLoading como true enquanto busca produtos',
        () async {
          when(mockRepository.getProducts()).thenAnswer(
            (_) async => Future.delayed(
              const Duration(milliseconds: 100),
              () => Result.ok(mockProducts),
            ),
          );

          final future = viewModel.getProducts();
          expect(viewModel.isLoading, true);
          await future;
        },
      );

      test(
        'deve preencher a lista de produtos em caso de sucesso na busca',
        () async {
          when(
            mockRepository.getProducts(),
          ).thenAnswer((_) async => Result.ok(mockProducts));

          await viewModel.getProducts();

          expect(viewModel.products.length, 2);
          expect(viewModel.products[0].title, 'Product 1');
          expect(viewModel.products[1].title, 'Product 2');
        },
      );

      test('deve definir isLoading como false após sucesso na busca', () async {
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Result.ok(mockProducts));

        await viewModel.getProducts();

        expect(viewModel.isLoading, false);
      });

      test('deve definir errorMessage em caso de falha na busca', () async {
        final exception = Exception('Failed to fetch products');
        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Result.error(exception));

        await viewModel.getProducts();

        expect(viewModel.errorMessage, isNotNull);
        expect(viewModel.errorMessage, contains('Failed to fetch products'));
      });

      test(
        'deve não preencher a lista de produtos em caso de falha na busca',
        () async {
          final exception = Exception('Failed to fetch products');
          when(
            mockRepository.getProducts(),
          ).thenAnswer((_) async => Result.error(exception));

          await viewModel.getProducts();

          expect(viewModel.products, isEmpty);
        },
      );
    });

    group('Testes de setErrorMessage', () {
      test('deve definir errorMessage', () {
        viewModel.setErrorMessage('Test error');

        expect(viewModel.errorMessage, 'Test error');
      });

      test('deve definir errorMessage como null', () {
        viewModel.setErrorMessage('Test error');
        viewModel.setErrorMessage(null);

        expect(viewModel.errorMessage, null);
      });
    });

    group('Testes de setIsLoading', () {
      test('deve definir isLoading como true', () {
        viewModel.setIsLoading(true);

        expect(viewModel.isLoading, true);
      });

      test('deve definir isLoading como false', () {
        viewModel.setIsLoading(true);
        viewModel.setIsLoading(false);

        expect(viewModel.isLoading, false);
      });
    });

    group('Testes de clearError', () {
      test('deve limpar errorMessage', () {
        viewModel.setErrorMessage('Test error');
        viewModel.clearError();

        expect(viewModel.errorMessage, null);
      });

      test('deve notificar listeners quando errorMessage é limpo', () {
        viewModel.setErrorMessage('Test error');

        var notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        viewModel.clearError();

        expect(notificationCount, 1);
      });
    });

    group('Testes de products getter', () {
      test('deve retornar lista imutável', () async {
        final mockProducts = [
          Product(
            id: 1,
            title: 'Product 1',
            price: 10.0,
            description: 'Description 1',
            category: 'Category 1',
            image: 'image1.jpg',
            rating: Rating(rate: 4.5, count: 100),
          ),
        ];

        when(
          mockRepository.getProducts(),
        ).thenAnswer((_) async => Result.ok(mockProducts));

        await viewModel.getProducts();

        expect(
          () => viewModel.products.add(
            Product(
              id: 2,
              title: 'Product 2',
              price: 20.0,
              description: 'Description 2',
              category: 'Category 2',
              image: 'image2.jpg',
              rating: Rating(rate: 4.0, count: 50),
            ),
          ),
          throwsUnsupportedError,
        );
      });
    });
  });
}
