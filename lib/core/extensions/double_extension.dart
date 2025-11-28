extension DoubleExtension on double {
  String get toCurrencyBr {
    return 'R\$ ${toStringAsFixed(2).replaceAll('.', ',')}';
  }
}
