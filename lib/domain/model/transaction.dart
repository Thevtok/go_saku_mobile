class Transaction {
  String transactionType;
  final String senderNumber;
  final String recipientNumber;
  final String senderName;
  final String recipientName;
  final DateTime transactionDate;
  int? senderID;
  int? recipientID;
  int? bankAccountID;
  int? cardID;
  int? peID;
  int? amount;
  int? point; // Nullable accountId

  Transaction({
    required this.transactionType,
    required this.transactionDate,
    required this.senderNumber,
    required this.senderName,
    required this.recipientName,
    required this.recipientNumber,
    this.senderID,
    this.recipientID,
    this.bankAccountID,
    this.cardID,
    this.peID,
    this.amount,
    this.point,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionType: json['transaction_type'] ?? '',
      transactionDate: json['transaction_date'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderNumber: json['sender_phone_number'],
      recipientName: json['recipient_name'],
      recipientID: json['recipient_id'],
      recipientNumber: json['recipient_phone_number'],
      senderID: json['sender_id'],
      bankAccountID: json['bank_account_id'],
      cardID: json['card_id'],
      peID: json['pe_id'],
      point: json['point'],
      amount: json['amount'],
    );
  }
}

class DepositBank {
  String transactionType;

  final String senderName;

  final DateTime transactionDate;
  int? senderID;

  int? bankAccountID;

  int? amount;

  DepositBank({
    this.transactionType = 'Deposit Bank',
    DateTime? transactionDate,
    required this.senderName,
    this.senderID,
    this.bankAccountID,
    required this.amount,
  }) : transactionDate = transactionDate ?? DateTime.now();

  factory DepositBank.fromJson(Map<String, dynamic> json) {
    return DepositBank(
      transactionType: json['transaction_type'] ?? 'Deposit Bank',
      transactionDate: DateTime.parse(json['transaction_date'] ?? ''),
      senderName: json['sender_name'] ?? '',
      senderID: json['sender_id'],
      bankAccountID: json['bank_account_id'],
      amount: json['amount'],
    );
  }
  Map<String, dynamic> toJson() {
    final now = DateTime.now().toUtc();
    final formattedDateTime = now.toIso8601String();

    return {
      'transaction_date': formattedDateTime,
      'sender_name': senderName,
      'senderID': senderID,
      'bank_account_id': bankAccountID,
      'amount': amount,
    };
  }
}
