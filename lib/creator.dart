class Creator {
  String account;
  int? patrons;
  Earnings? earnings;
  Creator({required this.account, this.patrons, this.earnings});
  bool limit() {
    return (earnings?.limit() ?? true) || ((patrons ?? 0) < 2);
  }
}

class Earnings {
  String currency;
  int value;
  Earnings({required this.currency, required this.value});
  bool limit() {
    return (currency == '\$' && value < 25) || value == 0;
  }
  String format() {
    return currency + value.toString();
  }
}
