class Creator {
  String account;
  int? patrons;
  Earnings? earnings;
  Creator({required this.account, this.patrons, this.earnings});
  bool limit() {
    return (earnings?.limit() ?? true) || (patrons ?? 0) < 2;
  }
}

class Earnings {
  int value;
  Earnings({required this.value});
  bool limit() {
    return value == 0;
  }
  String format() {
    return '\$' + value.toString();
  }
}
