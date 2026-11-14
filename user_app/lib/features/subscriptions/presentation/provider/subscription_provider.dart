import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user/config/app_env.dart';
import 'package:user/constants/app_colors.dart';
import 'package:user/constants/app_constants.dart';
import 'package:user/features/subscriptions/data/model/usersubscriptions_response_model.dart';
import 'package:user/features/subscriptions/domain/usecases/createsubscription_usecase.dart';
import 'package:user/features/subscriptions/domain/usecases/getsubscriptions_usecase.dart';
import 'package:user/network/logging_interceptor.dart';
import 'package:user/utils/services/prefs.dart';
import 'package:user/widgets/show_snackbar.dart';

class SubscriptionProvider extends ChangeNotifier {
  final GetUserSubscriptionsUsecase getUserSubscriptionsUsecase;
  final CreatesubscriptionUsecase createsubscriptionUsecase;
  // final CreatepaymentUsecase createpaymentUsecase;
  // final UpdatepaymentUsecase updatepaymentUsecase;
  // final AddcashsubscriptionUsecase addcashsubscriptionUsecase;
  // final GetSubscriptionsUsecase getSubscriptionsUsecase;
  // List<SubscriptionModel> _subscriptions = [];
  // List<SubscriptionModel> get subscriptions => _subscriptions;

  bool isLoading = false;

  void setLoader(bool value) {
    isLoading = value;
    notifyListeners();
  }

  final marketingIdController = TextEditingController();

  SubscriptionProvider(
    this.getUserSubscriptionsUsecase,
    this.createsubscriptionUsecase,
    // this.createpaymentUsecase,
    // this.updatepaymentUsecase,
    // this.addcashsubscriptionUsecase,
    // this.getSubscriptionsUsecase,
  );

  List<UserSubscriptionsData> _subscriptions = [];
  List<UserSubscriptionsData> get subscriptions => _subscriptions;
  String? errorMessage;

  Future<void> getUserSubsriptions() async {
    try {
      setLoader(true);

      errorMessage = null;
      notifyListeners();

      final data = await getUserSubscriptionsUsecase.getUserSubscriptions();

      setLoader(false);

      if (data.isLeft()) {
        // Error Case
        errorMessage = data.getLeft().error;
        // showSnackBar(
        //   message:
        //       errorMessage!.isNotEmpty ? errorMessage! : "Something went wrong",
        // );
      } else {
        // Success Case
        _subscriptions = data.getRight().data;

        notifyListeners();
      }
    } catch (e) {
      setLoader(false);
      showSnackBar(message: e.toString());
    }
  }

  // Future<void> getProviderSubsriptions() async {
  //   setLoader(true);
  //   errorMessage = null;
  //   notifyListeners();

  //   final data = await getProviderSubscriptionUsecase.getProviderSubscription();
  //   setLoader(false);

  //   if (data.isLeft()) {
  //     errorMessage = data.getLeft().error;
  //     //showSnackBar(message: data.getLeft().error);
  //   } else {
  //     _subscriptions = data.getRight().data;
  //     notifyListeners();
  //   }
  // }

  String? userSubId;

  Future<bool> createSubscription(String subId) async {
    try {
      setLoader(true);

      final data = await createsubscriptionUsecase.createSubscription(subId);

      if (data.isLeft()) {
        setLoader(false);
        showSnackBar(message: data.getLeft().error);
        return false;
      }

      userSubId = data.getRight().data.userSubId;
      log("userSubId: $userSubId");

      // await createPayment(subId);

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

  // Future<void> createPayment(String subId) async {
  //   final data = await createpaymentUsecase.createPayment(subId);

  //   if (data.isLeft()) {
  //     setLoader(false);
  //     showSnackBar(message: data.getLeft().error);
  //   } else {
  //     // Open Razorpay payment window
  //     await razorPaymentFunction(data.getRight().data.paymentId);
  //   }
  // }

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
        'contact': '${Prefs().getString(Prefs.fullName)}',
        'email': '${Prefs().getString(Prefs.email)}',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };
    logDebug('razorpay options----> $options');
    razorpay.open(options);
  }

  // Future<void> updatePayment(String userSubId) async {
  //   final data = await updatepaymentUsecase.updatePayment(userSubId);

  //   setLoader(false); // Hide loader after final API

  //   if (data.isLeft()) {
  //     showSnackBar(message: data.getLeft().error);
  //   } else {
  //     showSnackBar(message: data.getRight().message, bgColor: Colors.green);
  //   }
  // }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    debugPrint('Payment Success: ${response.paymentId}');
    // if (userSubId != null) {
    //   await updatePayment(userSubId!);
    // } else {
    //   setLoader(false);
    // }
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

  // Future<void> addCashSubscription(String subId) async {
  //   try {
  //     setLoader(true);
  //     final Map<String, dynamic> body = {
  //       "subscription_id": subId,
  //       "executive_id": marketingIdController.text.trim(),
  //     };
  //     final data = await addcashsubscriptionUsecase.addCashSubscription(body);

  //     if (data.isLeft()) {
  //       setLoader(false);
  //       showSnackBar(message: data.getLeft().error);
  //       return;
  //     }

  //     showSnackBar(message: data.getRight().message, bgColor: Colors.green);
  //   } catch (e) {
  //     setLoader(false);
  //     showSnackBar(message: "Something went wrong: $e");
  //   }
  // }
}
