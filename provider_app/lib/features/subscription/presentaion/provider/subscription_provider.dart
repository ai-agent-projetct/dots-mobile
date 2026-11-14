import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/config/app_env.dart';
import 'package:provider/constants/app_colors.dart';
import 'package:provider/constants/app_constants.dart';
import 'package:provider/features/onboarding/domain/usecase/getsubcategory_usecase.dart';
import 'package:provider/features/subscription/data/model/createsubscription_response_model.dart';
import 'package:provider/features/subscription/data/model/getsubscripions_response_model.dart';
import 'package:provider/features/subscription/data/model/subscription_response_model.dart';
import 'package:provider/features/subscription/domain/usecase/addcashsubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/createpayment_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/createsubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/getprovidersubscription_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/getsubscriptions_usecase.dart';
import 'package:provider/features/subscription/domain/usecase/updatepayment_usecase.dart';
import 'package:provider/utils/network/logging_interceptor.dart';
import 'package:provider/utils/services/prefs.dart';
import 'package:provider/widgets/show_snackbar.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionProvider extends ChangeNotifier {
  final GetProviderSubscriptionUsecase getProviderSubscriptionUsecase;
  final CreatesubscriptionUsecase createsubscriptionUsecase;
  final CreatepaymentUsecase createpaymentUsecase;
  final UpdatepaymentUsecase updatepaymentUsecase;
  final AddcashsubscriptionUsecase addcashsubscriptionUsecase;
  final GetSubscriptionsUsecase getSubscriptionsUsecase;
  List<SubscriptionModel> _subscriptions = [];
  List<SubscriptionModel> get subscriptions => _subscriptions;

  bool isLoading = false;

  void setLoader(bool value) {
    isLoading = value;
    notifyListeners();
  }

  final marketingIdController = TextEditingController();

  SubscriptionProvider(
    this.getProviderSubscriptionUsecase,
    this.createsubscriptionUsecase,
    this.createpaymentUsecase,
    this.updatepaymentUsecase,
    this.addcashsubscriptionUsecase,
    this.getSubscriptionsUsecase,
  );

  Future<void> getProviderSubsriptions() async {
    setLoader(true);
    final data = await getProviderSubscriptionUsecase.getProviderSubscription();
    setLoader(false);

    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      _subscriptions = data.getRight().data;
      notifyListeners();
    }
  }

  List<GetSubscriptionData> allsubscriptions = [];
  String? errorMessage;

  Future<void> getSubsriptions() async {
    try {
      setLoader(true);

      errorMessage = null;
      notifyListeners();

      final data = await getSubscriptionsUsecase.getSubscriptions();

      setLoader(false);

      if (data.isLeft()) {
        // Error Case
        errorMessage = data.getLeft().error;
        showSnackBar(
          message:
              errorMessage!.isNotEmpty ? errorMessage! : "Something went wrong",
        );
      } else {
        // Success Case
        allsubscriptions = data.getRight().data;

        notifyListeners();
      }
    } catch (e) {
      setLoader(false);
      showSnackBar(message: e.toString());
    }
  }

  String? prosubId;

  Future<bool> createSubscription(String subId) async {
    try {
      setLoader(true);

      final data = await createsubscriptionUsecase.createSubscription(subId);

      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
        return false;
      }

      prosubId = data.getRight().data.proSubId;
      log("ProSubId: $prosubId");

      await createPayment(subId);

      setLoader(false);
      return true;
    } catch (e) {
      setLoader(false);
      showSnackBar(message: "Something went wrong: $e");
      return false;
    }
  }

  final Razorpay razorpay = Razorpay();

  void setupRazorpayListeners() {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
  }

  Future<void> createPayment(String subId) async {
    final data = await createpaymentUsecase.createPayment(subId);

    if (data.isLeft()) {
      setLoader(false);
      showSnackBar(message: data.getLeft().error);
    } else {
      // Open Razorpay payment window
      await razorPaymentFunction(data.getRight().data.paymentId);
    }
  }

  razorPaymentFunction(paymentId) async {
    var options = {
      'key':
          (getEnv == Environment.prod || getEnv == Environment.stage)
              ? AppConstants.razorLiveKey
              : AppConstants.razorTestKey,
      'order_id': paymentId,
      'currency': "INR",
      'name': 'Dots',
      'prefill': {
        'contact':
            '${Prefs().getString(Prefs.firstName)} ${Prefs().getString(Prefs.lastName)}',
        'email': '${Prefs().getString(Prefs.email)}',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };
    logDebug('razorpay options----> $options');
    razorpay.open(options);
  }

  Future<void> updatePayment(String proSubId) async {
    final data = await updatepaymentUsecase.updatePayment(proSubId);

    setLoader(false); // Hide loader after final API

    if (data.isLeft()) {
      showSnackBar(message: data.getLeft().error);
    } else {
      showSnackBar(message: data.getRight().message, bgColor: Colors.green);
    }
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    debugPrint('Payment Success: ${response.paymentId}');
    if (prosubId != null) {
      await updatePayment(prosubId!);
    } else {
      setLoader(false);
    }
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) async {
    setLoader(false);
    debugPrint('Payment Failed: ${response.error}');
    showSnackBar(message: response.message!, bgColor: AppColors.red);
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) async {
    setLoader(false);
    debugPrint('wallet: ${response.walletName}');
  }

  Future<void> addCashSubscription(String subId) async {
    try {
      setLoader(true);
      final Map<String, dynamic> body = {
        "subscription_id": subId,
        "executive_id": marketingIdController.text.trim(),
      };
      final data = await addcashsubscriptionUsecase.addCashSubscription(body);

      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
        return;
      }

      showSnackBar(message: data.getRight().message, bgColor: Colors.green);
    } catch (e) {
      setLoader(false);
      showSnackBar(message: "Something went wrong: $e");
    }
  }
}
