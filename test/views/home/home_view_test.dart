import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/core/utils/result.dart';
import 'package:shopping_cart/domain/models/product.dart';
import 'package:shopping_cart/domain/usecases/usecases.dart';
import 'package:shopping_cart/viewmodels/cart/cart_store_viewmodel.dart';
import 'package:shopping_cart/viewmodels/home/home_viewmodel.dart';
import 'package:shopping_cart/views/home/home_view.dart';

import '../../helpers/test_data.dart';
import '../../viewmodels/cart/cart_store_viewmodel_test.mocks.dart';
import '../../viewmodels/home/home_viewmodel_test.mocks.dart';

void main() {
  late MockHomeRepository mockHomeRepository;
  late MockCartRepository mockCartRepository;
  late MockCheckoutRepository mockCheckoutRepository;
  late HomeViewmodel homeViewmodel;
  late CartStoreViewmodel cartStoreViewmodel;

  setUpAll(() {
    provideDummy<Result<List<Product>>>(Result.ok([]));
    provideDummy<Result<void>>(Result.ok(null));
    provideDummy<Result<bool>>(Result.ok(true));
  });

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    mockCartRepository = MockCartRepository();
    mockCheckoutRepository = MockCheckoutRepository();
    homeViewmodel = HomeViewmodel(homeRepository: mockHomeRepository);
    cartStoreViewmodel = CartStoreViewmodel(
      cartRepository: mockCartRepository,
      checkoutRepository: mockCheckoutRepository,
      addItemUseCase: AddItemToCartUseCase(),
      updateQuantityUseCase: UpdateItemQuantityUseCase(),
    );
  });

  Widget buildSubject() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeViewmodel>.value(value: homeViewmodel),
        ChangeNotifierProvider<CartStoreViewmodel>.value(
          value: cartStoreViewmodel,
        ),
      ],
      child: const MaterialApp(home: HomeView()),
    );
  }

  group('HomeView', () {
    testWidgets('exibe loading enquanto busca produtos', (tester) async {
      final completer = Completer<Result<List<Product>>>();
      when(
        mockHomeRepository.getProducts(),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());
      await tester.pump();

      expect(find.text('Carregando produtos...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      completer.complete(Result.ok([]));
      await tester.pump();
    });

    testWidgets('exibe lista vazia quando nao ha produtos', (tester) async {
      when(
        mockHomeRepository.getProducts(),
      ).thenAnswer((_) async => Result.ok([]));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump();

      expect(find.text('Nenhum produto disponível'), findsOneWidget);
    });

    testWidgets('exibe produtos em caso de sucesso', (tester) async {
      final products = [
        makeProduct(id: 1, title: 'Camiseta', price: 29.9),
        makeProduct(id: 2, title: 'Tenis', price: 199.0),
      ];
      when(
        mockHomeRepository.getProducts(),
      ).thenAnswer((_) async => Result.ok(products));

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump();

      expect(find.text('Camiseta'), findsOneWidget);
      expect(find.text('Tenis'), findsOneWidget);
      expect(find.text('Adicionar ao carrinho'), findsNWidgets(2));
      expect(find.text('Carregando produtos...'), findsNothing);
    });

    testWidgets('exibe snackbar de erro e lista vazia em caso de falha', (
      tester,
    ) async {
      when(mockHomeRepository.getProducts()).thenAnswer(
        (_) async => Result.error(Exception('Failed to fetch products')),
      );

      await tester.pumpWidget(buildSubject());
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Failed to fetch products'), findsOneWidget);
      expect(find.text('Nenhum produto disponível'), findsOneWidget);
    });
  });
}
