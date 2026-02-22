import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/views/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PaymentType extends StatefulWidget {
  const PaymentType({super.key});

  @override
  State<PaymentType> createState() => _PaymentType();
}

class _PaymentType extends State<PaymentType> {
  String selectedPayment = 'stripe'; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button and title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Payment Type',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // Stripe payment option
                _buildPaymentOption(
                  label: 'stripe',
                  isSelected: selectedPayment == 'stripe',
                  onTap: () {
                    setState(() {
                      selectedPayment = 'stripe';
                    });
                  },
                ),

                SizedBox(height: 16),

                // PayPal payment option
                _buildPaymentOption(
                  label: 'paypal',
                  isSelected: selectedPayment == 'paypal',
                  onTap: () {
                    setState(() {
                      selectedPayment = 'paypal';
                    });
                  },
                ),

                Spacer(),

                CustomButton(text: "Pay",onpress: (){Get.toNamed(Routes.paymentCard);},)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Color(0xFF1A1D2E).withOpacity(0.6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CustomColors.primaryColor
                : Color(0xFF2E3446),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Payment logo/icon
            if (label == 'stripe')
              Text(
                'stripe',
                style: TextStyle(
                  color: Color(0xFF635BFF),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              )
            else if (label == 'paypal')
              Row(
                children: [
                  Icon(
                    Icons.paypal_outlined,
                    color: Color(0xFF00A4E0),
                    size: 20,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'PayPal',
                    style: TextStyle(
                      color: Color(0xFF00A4E0),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            Spacer(),

            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? CustomColors.primaryColor
                      : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.primaryColor,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
