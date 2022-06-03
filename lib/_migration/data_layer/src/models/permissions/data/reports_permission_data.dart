import 'package:equatable/equatable.dart';

import '../../../../extensions.dart';

/// Permissions related to reports.
class ReportsPermissionsData extends Equatable {
  /// User has access to application issues.
  final bool applicationIssue;

  /// User has access to application notices.
  final bool applicationNotice;

  /// User can assign the data.
  final bool assign;

  /// User has access to customer care.
  final bool customerCare;

  /// User can edit the data.
  final bool edit;

  /// User has access to offer inquiries.
  final bool offerInquiry;

  /// User has access remaining data.
  final bool others;

  /// User has access to produce inquiries.
  final bool productInquiry;

  /// User has access to product services.
  final bool productsService;

  /// User has access to service feedback.
  final bool serviceFeedback;

  /// User has access to service inquiries.
  final bool serviceInquiry;

  /// Creates a [ReportsPermissionsData] object.
  const ReportsPermissionsData({
    this.applicationIssue = false,
    this.applicationNotice = false,
    this.assign = false,
    this.customerCare = false,
    this.edit = false,
    this.offerInquiry = false,
    this.others = false,
    this.productInquiry = false,
    this.productsService = false,
    this.serviceFeedback = false,
    this.serviceInquiry = false,
  });

  @override
  List<Object> get props => [
        applicationIssue,
        applicationNotice,
        assign,
        customerCare,
        edit,
        offerInquiry,
        others,
        productInquiry,
        productsService,
        serviceFeedback,
        serviceInquiry,
      ];

  /// Returns a copy of this permission with select different values.
  ReportsPermissionsData copyWith({
    bool? applicationIssue,
    bool? applicationNotice,
    bool? assign,
    bool? customerCare,
    bool? edit,
    bool? offerInquiry,
    bool? others,
    bool? productInquiry,
    bool? productsService,
    bool? serviceFeedback,
    bool? serviceInquiry,
  }) =>
      ReportsPermissionsData(
        applicationIssue: applicationIssue ?? this.applicationIssue,
        applicationNotice: applicationNotice ?? this.applicationNotice,
        assign: assign ?? this.assign,
        customerCare: customerCare ?? this.customerCare,
        edit: edit ?? this.edit,
        offerInquiry: offerInquiry ?? this.offerInquiry,
        others: others ?? this.others,
        productInquiry: productInquiry ?? this.productInquiry,
        productsService: productsService ?? this.productsService,
        serviceFeedback: serviceFeedback ?? this.serviceFeedback,
        serviceInquiry: serviceInquiry ?? this.serviceInquiry,
      );

  @override
  String toString() => '<'
      '${[
        '${applicationIssue.toLog('applicationIssue')}',
        '${applicationNotice.toLog('applicationNotice')}',
        '${assign.toLog('assign')}',
        '${customerCare.toLog('customerCare')}',
        '${edit.toLog('edit')}',
        '${offerInquiry.toLog('offerInquiry')}',
        '${others.toLog('others')}',
        '${productInquiry.toLog('productInquiry')}',
        '${productsService.toLog('productsService')}',
        '${serviceFeedback.toLog('serviceFeedback')}',
        '${serviceInquiry.toLog('serviceInquiry')}',
      ].logJoin()}'
      '>';
}
