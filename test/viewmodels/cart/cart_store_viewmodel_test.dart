import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_cart/core/app_constants.dart';
import 'package:shopping_cart/core/exceptions/cart_exception.dart';
import 'package:shopping_cart/core/utils/result.dart';
import 'package:shopping_cart/data/repositories/cart/cart_repository.dart';
import 'package:shopping_cart/data/repositories/checkout/checkout_repository.dart';
import 'package:shopping_cart/domain/usecases/usecases.dart';
import 'package:shopping_cart/viewmodels/cart/cart_store_viewmodel.dart';

import '../../helpers/test_data.dart';
import 'cart_store_viewmodel_test.mocks.dart';

@GenerateMocks([CartRepository, CheckoutRepository])
void main() {
  late CartStoreViewmodel viewModel;
  late MockCartRepository mockCartRepository;
  late MockCheckoutRepository mockCheckoutRepository;

  setUpAll(() {
    provideDummy<Result<void>>(Result.ok(null));
    provideDummy<Result<bool>>(Result.ok(true));
  });

  setUp(() {
    mockCartRepository = MockCartRepository();
    mockCheckoutRepository = MockCheckoutRepository();
    viewModel = CartStoreViewmodel(
      cartRepository: mockCartRepository,
      checkoutRepository: mockCheckoutRepository,
      addItemUseCase: AddItemToCartUseCase(),
      updateQuantityUseCase: UpdateItemQuantityUseCase(),
    );
  });

  group('CartStoreViewmodel', () {
    group('estado inicial', () {
      test('deve iniciar com carrinho vazio', () {
        expect(viewModel.cart.items, isEmpty);
        expect(viewModel.cart.totalItems, 0);
      });

      test('deve ter isLoading como false inicialmente', () {
        expect(viewModel.isLoading, false);
      });

      test('deve ter isRemoving como false inicialmente', () {
        expect(viewModel.isRemoving, false);
      });

      test('deve ter errorMessage como null inicialmente', () {
        expect(viewModel.errorMessage, null);
      });
    });

    group('addItem', () {
      test('deve adicionar produto ao carrinho', () {
        final product = makeProduct();

        viewModel.addItem(product);

        expect(viewModel.cart.totalDifferentItems, 1);
        expect(viewModel.cart.items.first.product.id, product.id);
        expect(viewModel.getItemQuantity(product), 1);
      });

      test('deve incrementar quantidade de produto ja adicionado', () {
        final product = makeProduct();

        viewModel.addItem(product);
        viewModel.addItem(product);

        expect(viewModel.cart.totalDifferentItems, 1);
        expect(viewModel.getItemQuantity(product), 2);
      });

      test('deve definir errorMessage ao atingir o limite de produtos', () {
        for (var i = 1; i <= AppConstants.maxItems; i++) {
          viewModel.addItem(makeProduct(id: i, title: 'P$i'));
        }

        viewModel.addItem(makeProduct(id: 99, title: 'Extra'));

        expect(viewModel.cart.totalDifferentItems, AppConstants.maxItems);
        expect(viewModel.errorMessage, isNotNull);
        expect(viewModel.errorMessage, contains('${AppConstants.maxItems}'));
      });

      test('deve notificar listeners ao adicionar item', () {
        var notifications = 0;
        viewModel.addListener(() => notifications++);

        viewModel.addItem(makeProduct());

        expect(notifications, 1);
      });
    });

    group('incrementItem e decrementItem', () {
      test('incrementItem deve aumentar a quantidade', () {
        final product = makeProduct();
        viewModel.addItem(product);

        viewModel.incrementItem(product);

        expect(viewModel.getItemQuantity(product), 2);
      });

      test('decrementItem deve diminuir a quantidade', () {
        final product = makeProduct();
        viewModel.addItem(product);
        viewModel.incrementItem(product);

        viewModel.decrementItem(product);

        expect(viewModel.getItemQuantity(product), 1);
      });

      test('decrementItem deve remover o item quando quantidade chega a 1', () {
        final product = makeProduct();
        viewModel.addItem(product);

        viewModel.decrementItem(product);

        expect(viewModel.cart.items, isEmpty);
        expect(viewModel.getItemQuantity(product), 0);
      });

      test('incrementItem de produto ausente nao altera o carrinho', () {
        viewModel.incrementItem(makeProduct(id: 99));

        expect(viewModel.cart.items, isEmpty);
      });
    });

    group('removeItem', () {
      test('deve remover o item em caso de sucesso', () async {
        final product = makeProduct();
        viewModel.addItem(product);
        when(
          mockCartRepository.removeItem(product),
        ).thenAnswer((_) async => Result.ok(null));

        await viewModel.removeItem(product);

        expect(viewModel.cart.items, isEmpty);
        expect(viewModel.isRemoving, false);
      });

      test('deve definir errorMessage em caso de CartException', () async {
        final product = makeProduct();
        viewModel.addItem(product);
        when(mockCartRepository.removeItem(product)).thenAnswer(
          (_) async => Result.error(
            CartException(message: 'Erro ao remover item. Tente novamente.'),
          ),
        );

        await viewModel.removeItem(product);

        expect(viewModel.cart.totalDifferentItems, 1);
        expect(
          viewModel.errorMessage,
          'Erro ao remover item. Tente novamente.',
        );
        expect(viewModel.isRemoving, false);
      });

      test('deve definir errorMessage em caso de erro generico', () async {
        final product = makeProduct();
        viewModel.addItem(product);
        when(mockCartRepository.removeItem(product)).thenAnswer(
          (_) async => Result.error(Exception('falha inesperada')),
        );

        await viewModel.removeItem(product);

        expect(viewModel.errorMessage, contains('falha inesperada'));
      });

      test('deve marcar isRemoving enquanto remove', () async {
        final product = makeProduct();
        viewModel.addItem(product);
        var sawRemoving = false;
        when(mockCartRepository.removeItem(product)).thenAnswer((_) async {
          sawRemoving = viewModel.isRemoving;
          return Result.ok(null);
        });

        await viewModel.removeItem(product);

        expect(sawRemoving, true);
        expect(viewModel.isRemoving, false);
      });
    });

    group('finalizePurchase', () {
      test(
        'deve retornar true e desligar loading em caso de sucesso',
        () async {
          when(
            mockCheckoutRepository.finalizePurchase(),
          ).thenAnswer((_) async => Result.ok(true));

          final success = await viewModel.finalizePurchase();

          expect(success, true);
          expect(viewModel.isLoading, false);
          expect(viewModel.errorMessage, null);
        },
      );

      test(
        'deve retornar false e preencher errorMessage em caso de falha',
        () async {
          when(mockCheckoutRepository.finalizePurchase()).thenAnswer(
            (_) async => Result.error(Exception('checkout falhou')),
          );

          final success = await viewModel.finalizePurchase();

          expect(success, false);
          expect(viewModel.isLoading, false);
          expect(viewModel.errorMessage, contains('checkout falhou'));
        },
      );

      test('deve marcar isLoading enquanto finaliza', () async {
        var sawLoading = false;
        when(mockCheckoutRepository.finalizePurchase()).thenAnswer((_) async {
          sawLoading = viewModel.isLoading;
          return Result.ok(true);
        });

        await viewModel.finalizePurchase();

        expect(sawLoading, true);
        expect(viewModel.isLoading, false);
      });
    });

    group('clear, getItemQuantity e erros', () {
      test('clear deve esvaziar o carrinho', () {
        viewModel.addItem(makeProduct());

        viewModel.clear();

        expect(viewModel.cart.items, isEmpty);
      });

      test('getItemQuantity deve retornar 0 para produto ausente', () {
        expect(viewModel.getItemQuantity(makeProduct()), 0);
      });

      test('clearError deve limpar errorMessage e notificar', () {
        viewModel.setErrorMessage('erro');
        var notifications = 0;
        viewModel.addListener(() => notifications++);

        viewModel.clearError();

        expect(viewModel.errorMessage, null);
        expect(notifications, 1);
      });

      test('setIsLoading deve atualizar o estado', () {
        viewModel.setIsLoading(true);
        expect(viewModel.isLoading, true);
        viewModel.setIsLoading(false);
        expect(viewModel.isLoading, false);
      });
    });
  });
}
