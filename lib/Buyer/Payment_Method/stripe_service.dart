import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_checkout/stripe_checkout.dart';
class StripeService {
  static String secretKey = "sk_test_51Q0KoaRtis4wlRiUr2pcIUE0leqTcz5ROFsSfV84abE2II7jJtApKTnzGKtLdQlKB5J8RCwAVhZEXDrwpyHAaxie00e2vKoiMQ";
  static String publishableKey = "pk_test_51Q0KoaRtis4wlRiU3OOA8NLcVqrKm45GhqhZqNRrtxIOrk8lNF4xutSyxXusBdaKK1uIDUBMY8Z4t0t68ShIDSFw00hpI1nLgM";
  static Future<dynamic> createCheckoutSession(List<dynamic> productItems,
      totalAmount,) async {
    final url = Uri.parse("https://api.stripe.com/v1/checkout/sessions");
    String lineItems = "";
    int index = 0;

    // Construct the line items
    productItems.forEach((val) {
      var productPrice = (val["productPrice"] * 100).round().toString();
      lineItems += "&line_items[$index][price_data][product_data][name]=${val['productName']}";
      lineItems += "&line_items[$index][price_data][unit_amount]=$productPrice";
      lineItems += "&line_items[$index][price_data][currency]=EUR";
      lineItems += "&line_items[$index][quantity]=${val['qty'].toString()}";
      index++;
    });

    try {
      // Perform the POST request to Stripe API
      final response = await http.post(
        url,
        body: 'success_url=https://checkout.stripe.dev/success&mode=payment$lineItems',
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      // Check if response is successful
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse.containsKey("id")) {
          return jsonResponse["id"];
        } else {
          throw Exception("Session ID not found in response");
        }
      } else {
        throw Exception(
            "Failed to create session. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error creating checkout session: $e");
      return null;
    }
  }

  static Future<dynamic> stripePaymentCheckout(List<dynamic> productItems,
      int subTotal,
      BuildContext context,
      bool mounted, {
        required Function onSuccess,
        required Function onCancel,
        required Function onError,
      }) async {
    // Create a checkout session
    final String? sessionId = await createCheckoutSession(
        productItems, subTotal);

    if (sessionId == null) {
      onError("Failed to create session. Session ID is null.");
      return;
    }

    try {
      final result = await redirectToCheckout(
        context: context,
        sessionId: sessionId,
        publishableKey: publishableKey,
        successUrl: "https://checkout.stripe.dev/success",
        canceledUrl: "https://checkout.stripe.dev/cancel",
      );

      if (mounted) {
        final text = result.when(
          redirected: () {
            print("Redirected successfully");
            return "Redirected successfully";
          },
          success: () {
            onSuccess();
          },
          canceled: () {
            onCancel();
          },
          error: (e) {
            onError(e);
          },
        );
        return text;
      }
    } catch (e) {
      onError("Error during redirect: $e");
    }
  }
}