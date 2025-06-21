import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:petadoption/helpers/locator.dart';
import 'package:petadoption/models/error_models/error_reponse.dart';
import 'package:petadoption/models/response_models/payment.dart';
import 'package:petadoption/services/api_service.dart';
import 'package:petadoption/services/global_service.dart';
import 'package:petadoption/viewModel/admin_view_models/secureMeetup_admin_view_model.dart';
import 'package:petadoption/viewModel/base_view_model.dart';
import '../models/hive_models/user.dart';
import '../models/response_models/meetup.dart';
import '../models/response_models/meetup_verification.dart';
import '../models/response_models/payment_intent_model.dart';
import '../services/dialog_service.dart';
import '../services/navigation_service.dart';

class PaymentViewModel extends BaseViewModel {
  NavigationService get _navigationService => locator<NavigationService>();
  IAPIService get _apiService => locator<IAPIService>();
  IDialogService get _dialogService => locator<IDialogService>();
  GlobalService get _globalService => locator<GlobalService>();
  Payment? payment;
  bool get isBusy => busy;
  SecureMeetupAdminViewModel get _meetupModel =>
      locator<SecureMeetupAdminViewModel>();
  // Controllers
  final amountController = TextEditingController();
  Meetup? meetup;
  User? user;
  initializePaymets(Meetup meetup, User user) {
    this.meetup = meetup;
    this.user = user;
  }

  Future<void> payCustom() async {
    final amount = int.tryParse(amountController.text) ?? 0;
    if (amount < 20) {
      _dialogService.showApiError(
          ErrorResponse(errorCode: 'VAL01', message: 'Minimum fee is ₨ 20'));

      return;
    }
    await pay(amount);
  }

  Future<void> addPayment(int amount) async {
    var payRes = await _apiService.addPayment(Payment(
        userId: user!.userId, amount: amount, meetupId: meetup!.meetupId));
    if (payRes.errorCode == "PA0004") {
      payment = payRes.data as Payment;
      var verRes = await _apiService.updateMeetupVerification(
          MeetupVerification(
              meetupId: meetup!.meetupId,
              paymentId: payment!.paymentId,
              paymentStatus: _meetupModel.paymentStatus[1]));
      if (verRes.errorCode == "PA0004") {
        await _meetupModel.getPaymentInfo(_globalService.getuser()!.userId);
        _meetupModel.isLock();
        _meetupModel.notifyListeners();
      }
    } else {
      return;
    }
  }

  Future<void> pay(int amount) => _payInternal(amount);

  // ─────────────────────────  PRIVATE
  Future<void> _payInternal(int amount) async {
    try {
      loading(true);

      /// 1️⃣  Ask *your* backend for a PaymentIntent
      final intentRes = await _apiService.createPaymentIntent(
        PaymentIntentRequest(amount: amount, meetupId: meetup!.meetupId ?? ""),
      );

      if (intentRes.errorCode != 'PA0004' || intentRes.data == null) {
        _dialogService.showApiError(ErrorResponse(
            errorCode: "500",
            message: 'Could Not Start Payment try Again Later'));
        loading(false);
        return;
      }

      final clientSecret = intentRes.data!.clientSecret;

      /// 2️⃣  Initialise the PaymentSheet (no BuildContext needed)
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Pet Adoption',
        ),
      );

      /// 3️⃣  Present the sheet to user
      try {
        await Stripe.instance.presentPaymentSheet();

        /// 4️⃣  Persist payment in your DB
        await addPayment(amount);

        /// 5️⃣  Beautiful success dialog
        await _dialogService.showSuccess(
            text: 'Payment Successful\n ₨ $amount has been charged.');
      } on StripeException catch (e) {
        _dialogService.showApiError(ErrorResponse(
            errorCode: "500",
            message: e.error.message ?? 'Payment cancelled.'));
      } catch (e, s) {
        _globalService.logError('Stripe sheet error', e.toString(), s);
        _dialogService.showApiError(ErrorResponse(
            errorCode: "500",
            message: 'Payment cancelled. \n Try Again later'));
      }
    } catch (e, s) {
      debugPrint("Error ${e.toString()} Stack ${s.toString()}");
    } finally {
      loading(false);
    }
  }
}
