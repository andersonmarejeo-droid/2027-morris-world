enum QuickMessageId {
  goodMove('QUICK_01'),
  congrats('QUICK_02'),
  goodGame('QUICK_03'),
  more('QUICK_04');

  const QuickMessageId(this.wireId);
  final String wireId;
}
