/// Holds the basic information to access the backend
class NetEndpoints {
  /// Creates [NetEndpoints].
  const NetEndpoints();

  static const String _customer = '/customer-aaa';
  static const String _infoBanking = '/infobanking';
  static const String _txnBanking = '/txnbanking';
  static const String _xstudio = '/xstudio';
  static const String _automation = '/automation';
  static const String _payment = '/payment';
  static const String _admin = '/admin/console';
  static const String _integration = '/integration';
  static const String _loyaltyEngine = '/loyalty-engine';
  static const String _engagement = '/engagement';
  static const String _renderingEngine = '/rendering-engine';
  static const String _stripe = '/stripe-gateway';

  /// The login endpoint
  String get login => '$_customer/v1/login';

  /// The access PIN endpoint
  String get checkAccessPin => '$_customer/v1/check_access_pin';

  /// The devices endpoint
  String get customerDevice => '$_customer/v1/device';

  /// The branch endpoint
  String get branch => '$_infoBanking/v1/branch';

  /// The customers endpoint
  String get customer => '$_infoBanking/v1/customer';

  /// The customer permission module endpoint
  String get customerPermissionModule => '$_customer/v1/module';

  /// The devices endpoint
  String get device => customerDevice;

  /// The device OTP endpoint
  String get deviceOtp => '$_infoBanking/v1/check_device_otp';

  /// The resend OTP endpoint
  String get resendOTP => '$_infoBanking/v1/resend_otp';

  /// The experience endpoint
  String get experience => '$_xstudio/v1/customer_experience';

  /// The prefix for infobanking links.
  String get infobankingLink => '$_infoBanking/v1';

  /// File endpoint
  String get file => '$_infoBanking/v1/file';

  /// The images endpoint
  String get images => '$_infoBanking/v1/image';

  /// The experience images endpoint
  String get experienceImage => '$images/xstudio';

  /// DPA - Gets the user task details
  String get userTaskDetails => '$_automation/v1/user_task_details';

  /// DPA - Lists all processes and all their version.
  String get listProcessesWithVersions => '$_automation/v1/list_processes';

  /// DPA - Lists all processes in their latest version.
  String get listProcesses => '$_automation/v1/process';

  /// Tasks - Lists all unassigned tasks.
  String get tasksUnassigned => '$_automation/v1/unassigned_tasks';

  /// Tasks - Current task by process id.
  String get userTask => '$_automation/v2/user_task/process_instance_id';

  /// Tasks - Lists tasks of a user.
  String get tasksUser => '$_automation/v2/user_task';

  /// Tasks - Lists history.
  String get tasksHistory => '$_automation/v1/previous_tasks';

  /// Tasks - Sets assignee of a task to a user.
  String get tasksClaim => '$_automation/v1/set_assignee';

  /// Tasks - Start task.
  String get taskStart => '$_automation/v1/start';

  /// Tasks - Resumes task.
  String get taskResume => '$_automation/v1/task_variables';

  /// Tasks - Previous step.
  String get taskPrevious => '$_automation/v1/previous';

  /// Tasks - Finish task.
  String get taskFinish => '$_automation/v1/finish_task';

  /// DPA - Delete process.
  String get dpaDelete => '$_automation/v1/delete_instance';

  /// DPA - Upload file to automation.
  String get dpaUploadFile => '$_automation/v1/upload_file';

  /// DPA - Get file from automation.
  String get dpaDownloadFile => '$_automation/v1/get_file';

  /// DPA - Delete file endpoint from automation.
  String get dpaDeleteFile => '$_automation/v1/file';

  /// The prefix for automation links.
  String get automationLink => '$_automation/v1';

  /// The user endpoint
  String get user => '$_customer/v1/user';

  /// The endpoint to change the password
  String get changePassword => user;

  /// The profile endpoint
  String get profile => '$_admin/v1/profile';

  ///The transfer endpoint
  String get transfer => '$_txnBanking/v1/transfer';

  ///The transferV2 endpoint
  String get transferV2 => '$_txnBanking/v2/transfer';

  /// The frequent transfers endpoint
  String get frequentTransfers => '$_txnBanking/v1/frequent_transfer';

  /// The accounts endpoint
  String get account => '$_infoBanking/v1/account';

  /// The cards endpoint
  String get card => '$_infoBanking/v1/card';

  /// The card info endpoint
  String get cardInfo => '$_infoBanking/v2/card_info';

  /// The beneficiaries endpoint
  String get beneficiary => '$_txnBanking/v1/beneficiary';

  /// The beneficiaries endpoint
  String get beneficiary2 => '$_txnBanking/v2/beneficiary';

  /// The beneficiary receipt
  String get beneficiaryReceipt => '$_txnBanking/v1/beneficiary_receipt';

  /// The bill endpoint
  String get bill => '$_payment/v1/bill';

  /// The validate bill endpoint
  String get validateBill => '$bill/validate';

  /// The countries endpoint
  String get country => '$_infoBanking/v1/country';

  ///The payment endpoint
  String get payment => '$_payment/v1/payment';

  ///The payment receipt endpoint
  String get paymentReceipt => '$_payment/v1/payment_receipt';

  ///The payment V2 endpoint
  String get paymentV2 => '$_payment/v2/payment';

  /// The biller endpoint
  String get biller => '$_payment/v1/biller';

  /// The services endpoint
  String get service => '$_payment/v1/service';

  ///The frequent payment endpoint
  String get frequentPayment => '$_payment/v1/frequent_payment';

  /// The forgot password endpoint
  String get forgotPassword => '$_customer/v1/password_forgot_by_txn_pin';

  /// The reset password endpoint
  String get resetPassword => '$_customer/v1/password_change';

  /// The transactions endpoint
  String get transaction => '$_infoBanking/v1/transaction';

  /// The filter transactions endpoint
  String get filterTransaction => '$_infoBanking/v1/filter/transaction';

  /// The message endpoint
  String get message => '$_infoBanking/v1/message';

  /// The currencies endpoint
  String get currency => '$_infoBanking/v1/currency';

  /// The registration endpoint
  String get register => '$_infoBanking/v2/register';

  /// The corporate registration endpoint
  String get registerCorporate => '$_infoBanking/v1/register_corporate';

  /// The registration endpoint
  String get finalizeRegistration => '$_infoBanking/v1/customer/register';

  /// The registration endpoint
  String get authenticate => '$_infoBanking/v1/customer/authenticate';

  /// The upcoming payments endpoint
  String get upcomingPayment => '$_infoBanking/v2/upcoming_payment';

  /// The account loans endpoint
  String get accountLoan => '$_infoBanking/v1/account_loan';

  /// The Queue and Requests endpoint
  String get queueRequest => '';

  /// The Requests endpoint
  String get requests => '';

  /// The financial data endpoint
  String get financialData => '$_infoBanking/v2/financial_data';

  /// Deposit certificate endpoint
  String get depositCertificate => '$transaction/deposit_certificate';

  /// The customer account endpoint
  String get customerAccount => '$_infoBanking/v1/customer_account';

  /// Deposit certificate endpoint
  String get accountCertificate => '$customerAccount/account_certificate';

  /// Official Bank Statement endpoint
  String get officialBankStatement => '$customerAccount/bank_statement';

  ///The offers endpoint
  String get offers => '$_loyaltyEngine/v1/offer';

  ///[Category] - Fetch all categories
  String get category => '$_infoBanking/v1/category';

  /// The account loan payment endpoint
  String get accountLoanPayment => '$_infoBanking/v1/account_loan_payment';

  ///The offer transactions endpoint
  String get offerTransactions => '$_loyaltyEngine/v1/offer_transaction';

  ///The settings endpoint
  String get settings => '$_infoBanking/v1/setting';

  ///The unread alerts count
  String get unreadAlertsCount => '$_infoBanking/v1/activity/unread_count';

  ///Loyalty endpoint
  String get loyalty => '$_loyaltyEngine/v1/loyalty';

  ///Loyalty transactions endpoint
  String get loyaltyTransaction => '$_loyaltyEngine/v1/transaction';

  ///Loyalty burn points
  String get loyaltyBurn => '$_loyaltyEngine/v1/burn';

  ///Loyalty burn rate
  String get loyaltyBurnRate => '$_loyaltyEngine/v1/burn_rate';

  ///Loyalty current burn rate
  String get loyaltyBurnRateCurrent => '$loyaltyBurnRate/current';

  ///Loyalty points expiry
  String get loyaltyExpiry => '$_loyaltyEngine/v1/expiry';

  /// The endpoint that allows to post a client challenge question for the OCRA
  /// mutual authentication flow.
  String get ocraChallenge => '$_customer/v1/ocra/challenge';

  /// The endpoint that allows to post a result for the server challenge
  /// question for the OCRA mutual authentication flow.
  String get ocraResult => '$_customer/v1/ocra/response';

  /// Base endpoint for Integration
  String get integration => '$_integration/v1';

  /// Endpoint for getting appointments
  String get appointments => '$integration/branch/appointment';

  /// Verifies if the activation code was already introduced into the console
  /// by the bank for the user to be able to login.
  String get verifyActivationCode => '$_customer/v1/verify_activation';

  /// Sets the access pin for a new user.
  String get accessPin => '$_customer/v1/access_pin';

  /// Endpoint for getting Products
  String get products => '$_infoBanking/v1/product';

  /// Endpoint for getting customer roles
  String get customerRoles => '$_customer/v1/role';

  /// Endpoint for verifying the device on login
  String get verifyDeviceLogin => '$_customer/v1/verify_device_login';

  /// The campaigns endpoint
  String get campaign => '$_engagement/v1/customer_campaign';

  /// Endpoint for getting customer audits
  String get customerAudits => '$_customer/v1/audit';

  /// Endpoint for getting customer checkbooks
  String get checkbooks => '$_infoBanking/v1/checkbook';

  /// The transfer limits
  String get transferLimits => '$_txnBanking/v1/limit';

  /// The workflow-engine task endpoint.
  String get task => '';

  /// The international beneficiary
  String get internationalBeneficiary =>
      '$_txnBanking/v1/international_beneficiary';

  /// Endpoint for getting html/image/pdf rendered on server
  String get moreInfo => '$_renderingEngine/v1/render/more_info';

  /// Endpoint for getting Mandate payments
  String get mandatePayments => '$_txnBanking/v1/mandate_payment';

  /// Endpoint for getting Mandates
  String get mandates => '$_txnBanking/v1/mandate';

  /// Endpoint for both account and card top ups.
  String get topUp => '$_stripe/v1/topup';

  /// Endpoint for top up receipts.
  String get topUpReceipt => '$_stripe/v1/payment_receipt';

  /// Endpoint for the activities
  String get activity => '$_infoBanking/v1/activity';

  /// Endpoint for getting the banks.
  String get bank => '$_infoBanking/v1/bank';

  /// Endpoint for creating a shortcut.
  String get shortcut => '$_customer/v1/shortcut';

  /// Endpoint for evaluating a transfer.
  String get evaluateTransfer => '$_txnBanking/v1/transfer/evaluate';

  /// Endpoint for submitting a transfer.
  String get submitTransfer => '$_txnBanking/v2/transfer';

  /// Endpoint for getting the receipt for a transfer.
  String get transferReceipt => '$_txnBanking/v1/transfer_receipt';

  /// Endpoint for deleting a request
  String get request => '$_customer/v1/request';

  /// Endpoint for the customer limits
  String get customerLimits => '$_txnBanking/v2/customer_limit';

  /// Endpoint for handling inbox calls
  String get report => '$_engagement/v1/report';

  /// Endpoint for handling report messages
  String get inboxMessage => '$_engagement/v2/message';

  /// Endpoint for sending chat report messages
  String get reportMessage => '$_engagement/v1/message';

  /// Endpoint for getting the balance
  String get balance => '$_infoBanking/v2/balance/periodical_balance';

  /// Endpoint for getting the spent this month
  String get incomeExpense => '$_infoBanking/v2/balance/income_expense';

  /// Endpoint for handling alerts
  String get alert => '$_infoBanking/v1/alert';

  /// Endpoint for posting new pay to mobile flows.
  String get sendMoney => '$_txnBanking/v1/send_money';

  /// Endpoint for resending the withdrawal code from a pay to mobile.
  String get resendSendMoney => '$_txnBanking/v1/resend_send_money';

  /// Endpoint for the pay to mobile receipts.
  String get sendMoneyReceipt => '$_txnBanking/v1/send_money_receipt';

  /// Meawallet TOTP.
  String get meawalletTOTP => '$_integration/v1/totp';

  /// Endpoint for validate the transaction pin
  String get validateTransactionPin => '$_customer/v1/txn_pin';
}
