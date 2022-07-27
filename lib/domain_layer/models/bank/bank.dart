import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Model representing a bank.
class Bank extends Equatable {
  /// The bic code for the bank.
  final String? bic;

  /// The bank name.
  final String? name;

  /// First field for the address.
  final String? address1;

  /// Second field for the address.
  final String? address2;

  /// The code for the country the bank is based.
  final String? countryCode;

  /// Date when the bank was created.
  final DateTime? created;

  /// Last time the bank was updated.
  final DateTime? updated;

  /// The country this bank is based.
  final Country? country;

  /// The transfer type for this bank.
  final TransferType? transferType;

  /// The image url.
  final String? imageUrl;

  /// The category.
  /// TODO: check with BE what are the available options and map into an enum.
  final String? category;

  /// The bank code
  final String? code;

  /// The branch code.
  final String? branchCode;

  /// The branch name.
  final String? branchName;

  /// Creates a new [Bank].
  Bank({
    this.bic,
    this.name,
    this.address1,
    this.address2,
    this.countryCode,
    this.created,
    this.updated,
    this.country,
    this.transferType,
    this.imageUrl,
    this.category,
    this.code,
    this.branchCode,
    this.branchName,
  });

  /// Creates a copy with the passed parameters.
  Bank copyWith({
    String? bic,
    String? name,
    String? address1,
    String? address2,
    String? countryCode,
    DateTime? created,
    DateTime? updated,
    Country? country,
    TransferType? transferType,
    String? imageUrl,
    String? category,
    String? code,
    String? branchCode,
    String? branchName,
  }) =>
      Bank(
        bic: bic ?? this.bic,
        name: name ?? this.name,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        countryCode: countryCode ?? this.countryCode,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        country: country ?? this.country,
        transferType: transferType ?? this.transferType,
        imageUrl: imageUrl ?? this.imageUrl,
        category: category ?? this.category,
        code: code ?? this.code,
        branchCode: branchCode ?? this.branchCode,
        branchName: branchName ?? this.branchName,
      );

  @override
  List<Object?> get props => [
        bic,
        name,
        address1,
        address2,
        countryCode,
        created,
        updated,
        country,
        transferType,
        imageUrl,
        category,
        code,
        branchCode,
        branchName,
      ];
}
