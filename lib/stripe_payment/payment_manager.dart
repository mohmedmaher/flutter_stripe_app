// import the error handler
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_stripe_app/stripe_payment/error_handlers.dart';
import 'package:flutter_stripe_app/stripe_payment/stripe_keys.dart';

abstract class PaymentManager {
  static Future<void> makePayment(int amount, String currency) async {
    try {
      String clientSecret = await _getClientSecret((amount * 100).toString(), currency);
      await _initializePaymentSheet(clientSecret);
      await Stripe.instance.presentPaymentSheet();
    } on DioException catch (dioError) {
      // استخدم المعالج للتعامل مع أخطاء Dio
      throw Exception(ErrorHandler.handleDioError(dioError));
    } on StripeException catch (stripeError) {
      // استخدم المعالج للتعامل مع أخطاء Stripe
      throw Exception(ErrorHandler.handleStripeError(stripeError));
    } catch (error) {
      // استخدم المعالج للأخطاء العامة
      throw Exception(ErrorHandler.handleGeneralError(error));
    }
  }

  static Future<void> _initializePaymentSheet(String clientSecret) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: "mohammed",
        ),
      );
    } on StripeException catch (stripeError) {
      throw Exception(ErrorHandler.handleStripeError(stripeError));
    } catch (error) {
      throw Exception(ErrorHandler.handleGeneralError(error));
    }
  }

  static Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();
    try {
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ApiKeys.secretKey}',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: {
          'amount': amount,
          'currency': currency,
        },
      );

      if (response.statusCode == 200) {
        return response.data["client_secret"];
      } else {
        throw Exception('Failed to fetch client secret: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (dioError) {
      throw Exception(ErrorHandler.handleDioError(dioError));
    } catch (error) {
      throw Exception(ErrorHandler.handleGeneralError(error));
    }
  }
}
