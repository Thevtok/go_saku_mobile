import 'package:intl/intl.dart';

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
  String bankName; // Tambahkan properti untuk bankName
  String accountNumber;

  Transaction({
    required this.transactionType,
    DateTime? transactionDate,
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
    required this.bankName,
    required this.accountNumber,
  }) : transactionDate = transactionDate ?? DateTime.now();
  factory Transaction.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate =
        DateFormat('yyyy-MM-dd').parse(json['transaction_date'] ?? '');
    DateTime transactionDate =
        DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

    return Transaction(
      transactionType: json['transaction_type'] ?? '',
      transactionDate: transactionDate,
      senderName: json['sender_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountNumber: json['bank_account_number'] ?? '',
      senderNumber: json['sender_phone_number'] ?? '',
      recipientName: json['recipient_name'] ?? '',
      recipientID: json['recipient_id'] ?? 0,
      recipientNumber: json['recipient_phone_number'] ?? '',
      senderID: json['sender_id'] ?? 0,
      bankAccountID: json['bank_account_id'] ?? 0,
      cardID: json['card_id'] ?? 0,
      peID: json['pe_id'] ?? 0,
      point: json['point'] ?? 0,
      amount: json['amount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final now = DateTime.now().toLocal();

    final formattedDateTime =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return {
      'transaction_date': formattedDateTime,
      'sender_name': senderName,
      'senderID': senderID,
      'sender_phone_number': senderNumber,
      'recipient_phone_number': recipientNumber,
      'recipient_id': recipientID,
      'recipient_name': recipientName,
      'amount': amount,
      'bank_name': bankName,
      'bank_account_number': accountNumber
    };
  }
}

class DepositBank {
  String transactionType;

  final String senderName;

  final DateTime transactionDate;
  int? senderID;

  int? bankAccountID;

  int? amount;
  String bankName; // Tambahkan properti untuk bankName
  String accountNumber;

  DepositBank({
    this.transactionType = 'Deposit Bank',
    DateTime? transactionDate,
    required this.senderName,
    this.senderID,
    this.bankAccountID,
    required this.amount,
    required this.bankName,
    required this.accountNumber,
  }) : transactionDate = transactionDate ?? DateTime.now();

  factory DepositBank.fromJson(Map<String, dynamic> json) {
    return DepositBank(
      transactionType: json['transaction_type'] ?? 'Deposit Bank',
      transactionDate: DateTime.parse(json['transaction_date'] ?? ''),
      senderName: json['sender_name'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountNumber: json['bank_account_number'] ?? '',
      senderID: json['sender_id'],
      bankAccountID: json['bank_account_id'],
      amount: json['amount'],
    );
  }
  Map<String, dynamic> toJson() {
    final now = DateTime.now().toLocal();

    final formattedDateTime =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return {
      'transaction_date': formattedDateTime,
      'sender_name': senderName,
      'senderID': senderID,
      'bank_account_id': bankAccountID,
      'amount': amount,
      'bank_name': bankName,
      'bank_account_number': accountNumber
    };
  }
}

class Transfer {
  String transactionType;

  final String senderName;
  final String senderPhone;
  final String recipientName;
  final String recipientPhone;

  final DateTime transactionDate;
  int? senderID;
  int? recipientID;

  int? amount;

  Transfer({
    this.transactionType = 'Transfer',
    DateTime? transactionDate,
    required this.senderName,
    required this.senderPhone,
    required this.recipientName,
    required this.recipientPhone,
    this.senderID,
    this.recipientID,
    required this.amount,
  }) : transactionDate = transactionDate ?? DateTime.now();

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      transactionType: json['transaction_type'] ?? 'Transfer',
      transactionDate: DateTime.parse(json['transaction_date'] ?? ''),
      senderName: json['sender_name'] ?? '',
      recipientName: json['recipient_name'] ?? '',
      senderID: json['sender_id'],
      recipientID: json['recipient_id'],
      senderPhone: json['sender_phone_number'] ?? '',
      recipientPhone: json['recipient_phone_number'] ?? '',
      amount: json['amount'],
    );
  }
  Map<String, dynamic> toJson() {
    final now = DateTime.now().toLocal();

    final formattedDateTime =
        '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return {
      'transaction_date': formattedDateTime,
      'sender_name': senderName,
      'senderID': senderID,
      'sender_phone_number': senderPhone,
      'recipient_phone_number': recipientPhone,
      'recipient_id': recipientID,
      'recipient_name': recipientName,
      'amount': amount,
    };
  }
}
