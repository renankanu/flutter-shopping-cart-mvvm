import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_cart/core/utils/result.dart';
import 'package:shopping_cart/domain/models/cart.dart';
import 'package:shopping_cart/domain/usecases/update_item_quantity_usecase.dart';

import '../../helpers/test_data.dart';

void main() {
  late UpdateItemQuantityUseCase useCase;

  setUp(() {
    useCase = UpdateItemQuantityUseCase();
  });

  group('UpdateItemQuantityUseCase.increment', () {
    test('deve incrementar a quantidade do produto existente', () {
      final product = makeProduct();
      final cart = makeCartWithProducts(1, quantity: 2);

      final result = useCase.increment(cart, product);

      expect(result, isA<Ok<Cart>>());
      expect((result as Ok<Cart>).value.items.first.quantity, 3);
    });

    test('deve retornar o mesmo carrinho se o produto nao existir', () {
      final cart = makeCartWithProducts(1);
      final missing = makeProduct(id: 99, title: 'Missing');

      final result = useCase.increment(cart, missing);

      expect(result, isA<Ok<Cart>>());
      final updated = (result as Ok<Cart>).value;
      expect(updated.totalDifferentItems, 1);
      expect(updated.items.first.quantity, 1);
    });
  });

  group('UpdateItemQuantityUseCase.decrement', () {
    test('deve decrementar a quantidade quando ela for maior que 1', () {
      final product = makeProduct();
      final cart = makeCartWithProducts(1, quantity: 3);

      final result = useCase.decrement(cart, product);

      expect(result, isA<Ok<Cart>>());
      expect((result as Ok<Cart>).value.items.first.quantity, 2);
    });

    test('deve remover o item quando a quantidade chegar a zero', () {
      final product = makeProduct();
      final cart = makeCartWithProducts(1, quantity: 1);

      final result = useCase.decrement(cart, product);

      expect(result, isA<Ok<Cart>>());
      expect((result as Ok<Cart>).value.items, isEmpty);
    });

    test('deve retornar o mesmo carrinho se o produto nao existir', () {
      final cart = makeCartWithProducts(1);
      final missing = makeProduct(id: 99, title: 'Missing');

      final result = useCase.decrement(cart, missing);

      expect(result, isA<Ok<Cart>>());
      expect((result as Ok<Cart>).value.totalDifferentItems, 1);
    });

    test('nao altera o carrinho original ao decrementar', () {
      final original = makeCartWithProducts(1, quantity: 2);
      useCase.decrement(original, makeProduct());

      expect(original.items.first.quantity, 2);
    });
  });
}
