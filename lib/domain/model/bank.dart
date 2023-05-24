class Bank {
  final String accountNumber;
  final String bankName;
  final String name;
  int? accountId;
  String? userId; // Nullable accountId

  Bank(
      {required this.accountNumber,
      required this.bankName,
      required this.name,
      this.accountId,
      this.userId // Tambahkan accountId sebagai parameter opsional
      });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      name: json['account_holder_name'] ?? '',
      accountId: json['account_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_holder_name': name,
      'bank_name': bankName,
      'account_number': accountNumber,
    };
  }
}
