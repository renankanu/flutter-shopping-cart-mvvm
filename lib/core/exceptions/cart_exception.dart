class CartException implements Exception {
  final String message;

  CartException({required this.message});

  @override
  String toString() {
    return 'CartException: $message';
  }
}
