// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class Transaction {
  int? tx_id;
  final DateTime transaction_date;
  String transaction_type;
  String? deposit_bank_name;
  String? deposit_bank_number;
  String? deposit_account_bank_name;
  int? deposit_amount;
  String? deposit_status;
  String? withdraw_bank_name;
  String? withdraw_bank_number;
  String? withdraw_account_bank_name;
  int? withdraw_amount;
  String? withdraw_status;
  String? transfer_sender_name;
  String? transfer_recipient_name;
  String? transfer_sender_phone;
  String? transfer_recipient_phone;
  int? transfer_amount;
  String? transfer_status;

  Transaction({
    this.tx_id,
    required this.transaction_date,
    required this.transaction_type,
    this.deposit_bank_name,
    this.deposit_bank_number,
    this.deposit_account_bank_name,
    this.deposit_amount,
    this.deposit_status,
    this.withdraw_bank_name,
    this.withdraw_bank_number,
    this.withdraw_account_bank_name,
    this.withdraw_amount,
    this.withdraw_status,
    this.transfer_sender_name,
    this.transfer_recipient_name,
    this.transfer_sender_phone,
    this.transfer_recipient_phone,
    this.transfer_amount,
    this.transfer_status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      tx_id: json['tx_id'],
      transaction_date: DateTime.parse(json['transaction_date'] ?? ''),
      transaction_type: json['transaction_type'] ?? '',
      deposit_bank_name: json['deposit_bank_name'],
      deposit_bank_number: json['deposit_bank_number'],
      deposit_account_bank_name: json['deposit_account_bank_name'],
      deposit_amount: json['deposit_amount'],
      deposit_status: json['deposit_status'],
      withdraw_bank_name: json['withdraw_bank_name'],
      withdraw_bank_number: json['withdraw_bank_number'],
      withdraw_account_bank_name: json['withdraw_account_bank_name'],
      withdraw_amount: json['withdraw_amount'],
      withdraw_status: json['withdraw_status'],
      transfer_sender_name: json['transfer_sender_name'],
      transfer_recipient_name: json['transfer_recipient_name'],
      transfer_sender_phone: json['transfer_sender_phone'],
      transfer_recipient_phone: json['transfer_recipient_phone'],
      transfer_amount: json['transfer_amount'],
      transfer_status: json['transfer_status'],
    );
  }
}

class DepositBank {
  int? depositID;
  String? userID;
  int? amount;
  String bankName;
  String accountNumber;
  String accountHolderName;
  String transactionType;
  int? transactionsID;
  int? tx_id;

  final DateTime transactionDate;

  int? bankAccountID;

  DepositBank({
    this.depositID,
    this.userID,
    this.amount,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    this.transactionType = 'Deposit',
    this.transactionsID,
    this.tx_id,
    DateTime? transactionDate,
    this.bankAccountID,
  }) : transactionDate = transactionDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final formattedDateTime =
        '${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}';
    return {
      'deposit_id': depositID,
      'user_id': userID,
      'amount': amount,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_holder_name': accountHolderName,
      'transaction_type': transactionType,
      'transactions_id': transactionsID,
      'tx_id': tx_id,
      'transaction_ate': formattedDateTime,
      'account_id': bankAccountID,
    };
  }
}

class DepositResponse {
  bool status;
  int statusCode;
  String message;
  MidtransResult result;

  DepositResponse({
    required this.status,
    required this.statusCode,
    required this.message,
    required this.result,
  });

  factory DepositResponse.fromJson(Map<String, dynamic> json) {
    return DepositResponse(
      status: json['status'],
      statusCode: json['statusCode'],
      message: json['message'],
      result: MidtransResult.fromJson(json['result']),
    );
  }
}

class MidtransResult {
  String token;
  String redirectUrl;

  MidtransResult({
    required this.token,
    required this.redirectUrl,
  });

  factory MidtransResult.fromJson(Map<String, dynamic> json) {
    final resultJson = jsonDecode(json['body_midtrans']);
    return MidtransResult(
      token: resultJson['result']['token'],
      redirectUrl: resultJson['result']['redirect_url'],
    );
  }
}

class Transfer {
  int? transferID;
  int? senderID;
  int? recipientID;
  final String senderName;
  final String senderPhone;
  final String recipientName;
  final String recipientPhone;
  String transactionType;
  int? transactionsID;
  int? tx_id;

  final DateTime transactionDate;

  int? amount;

  Transfer({
    this.transferID,
    this.senderID,
    this.recipientID,
    required this.senderName,
    required this.senderPhone,
    required this.recipientName,
    required this.recipientPhone,
    this.transactionType = 'Transfer',
    this.transactionsID,
    this.tx_id,
    DateTime? transactionDate,
    this.amount,
  }) : transactionDate = transactionDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final formattedDateTime =
        '${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}';
    return {
      'transfer_id': transferID,
      'sender_id': senderID,
      'recipient_id': recipientID,
      'sender_name': senderName,
      'sender_phone_number': senderPhone,
      'recipient_name': recipientName,
      'recipient_Phone_number': recipientPhone,
      'transaction_type': transactionType,
      'transactions_id': transactionsID,
      'tx_id': tx_id,
      'transaction_date': formattedDateTime,
      'amount': amount,
    };
  }
}

class Withdraw {
  int? withdrawID;
  String? userID;
  int? amount;
  String bankName;
  String accountNumber;
  String accountHolderName;
  String transactionType;
  int? transactionsID;
  int? tx_id;

  final DateTime transactionDate;

  int? bankAccountID;

  Withdraw({
    this.withdrawID,
    this.userID,
    this.amount,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    this.transactionType = 'Withdraw',
    this.transactionsID,
    this.tx_id,
    DateTime? transactionDate,
    this.bankAccountID,
  }) : transactionDate = transactionDate ?? DateTime.now();

  Map<String, dynamic> toJson() {
    final formattedDateTime =
        '${transactionDate.year.toString().padLeft(4, '0')}-${transactionDate.month.toString().padLeft(2, '0')}-${transactionDate.day.toString().padLeft(2, '0')}';
    return {
      'withdraw_id': withdrawID,
      'user_id': userID,
      'amount': amount,
      'bank_name': bankName,
      'account_number': accountNumber,
      'account_holder_name': accountHolderName,
      'transaction_type': transactionType,
      'transactions_id': transactionsID,
      'tx_id': tx_id,
      'transaction_ate': formattedDateTime,
      'account_id': bankAccountID,
    };
  }
}
