import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/core/app_constants.dart';
import 'package:shopping_cart/core/exceptions/cart_exception.dart';
import 'package:shopping_cart/core/utils/result.dart';
import 'package:shopping_cart/domain/models/cart.dart';
import 'package:shopping_cart/domain/usecases/add_item_to_cart_usecase.dart';

import '../../helpers/test_data.dart';

void main() {
  late AddItemToCartUseCase useCase;

  setUp(() {
    useCase = AddItemToCartUseCase();
  });

  group('AddItemToCartUseCase', () {
    test('deve adicionar um produto novo ao carrinho vazio', () {
      final product = makeProduct();
      final result = useCase.execute(Cart.empty(), product);

      expect(result, isA<Ok<Cart>>());
      final cart = (result as Ok<Cart>).value;
      expect(cart.totalDifferentItems, 1);
      expect(cart.items.first.product.id, product.id);
      expect(cart.items.first.quantity, 1);
    });

    test('deve incrementar a quantidade quando o produto ja existe', () {
      final product = makeProduct();
      final cartWithItem = makeCartWithProducts(1, quantity: 2);

      final result = useCase.execute(cartWithItem, product);

      expect(result, isA<Ok<Cart>>());
      final cart = (result as Ok<Cart>).value;
      expect(cart.totalDifferentItems, 1);
      expect(cart.items.first.quantity, 3);
    });

    test(
      'deve recusar um produto novo quando o limite de itens diferentes e atingido',
      () {
        final fullCart = makeCartWithProducts(AppConstants.maxItems);
        final extra = makeProduct(id: 99, title: 'Extra');

        final result = useCase.execute(fullCart, extra);

        expect(result, isA<Error<Cart>>());
        final error = (result as Error<Cart>).error;
        expect(error, isA<CartException>());
        expect(
          (error as CartException).message,
          contains('${AppConstants.maxItems}'),
        );
      },
    );

    test(
      'nao altera o carrinho original ao adicionar (immutability do resultado)',
      () {
        final original = Cart.empty();
        final result = useCase.execute(original, makeProduct());

        expect(original.items, isEmpty);
        expect((result as Ok<Cart>).value.items, isNotEmpty);
      },
    );

    test('deve calcular subtotal com o item adicionado', () {
      final product = makeProduct(price: 15.5);
      final result = useCase.execute(Cart.empty(), product);

      final cart = (result as Ok<Cart>).value;
      expect(cart.subtotal, 15.5);
      expect(cart.totalItems, 1);
    });
  });
}
