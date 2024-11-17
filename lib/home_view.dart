
import 'package:flutter/material.dart';
import 'package:flutter_stripe_app/stripe_payment/payment_manager.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: ()=>PaymentManager.makePayment(20, "USD"),
            child: const Text("Pay 20 dollar"),
          )
        ],
      ),
    );
  }
}
