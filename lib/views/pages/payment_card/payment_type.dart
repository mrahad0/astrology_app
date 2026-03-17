// lib/views/pages/payment_card/payment_type.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/color.dart';
import 'package:astrology_app/utils/responsive.dart';
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveHelper.padding(20)),
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
                      size: ResponsiveHelper.iconSize(20),
                    ),
                  ),
                  SizedBox(width: ResponsiveHelper.space(12)),
                  Text(
                    'Payment Type',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveHelper.fontSize(20),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              SizedBox(height: ResponsiveHelper.space(30)),

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

              SizedBox(height: ResponsiveHelper.space(16)),

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

              const Spacer(),

              CustomButton(
                text: "Pay",
                onpress: () {
                  Get.toNamed(Routes.paymentCard);
                },
              )
            ],
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
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.padding(20),
          vertical: ResponsiveHelper.padding(18),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D2E).withOpacity(0.6),
          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
          border: Border.all(
            color: isSelected ? CustomColors.primaryColor : const Color(0xFF2E3446),
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
                  color: const Color(0xFF635BFF),
                  fontSize: ResponsiveHelper.fontSize(24),
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              )
            else if (label == 'paypal')
              Row(
                children: [
                   Icon(
                    Icons.paypal_outlined,
                    color: const Color(0xFF00A4E0),
                    size: ResponsiveHelper.iconSize(20),
                  ),
                  SizedBox(width: ResponsiveHelper.space(4)),
                  Text(
                    'PayPal',
                    style: TextStyle(
                      color: const Color(0xFF00A4E0),
                      fontSize: ResponsiveHelper.fontSize(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            const Spacer(),

            // Radio button
            Container(
              width: ResponsiveHelper.width(24),
              height: ResponsiveHelper.height(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? CustomColors.primaryColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: ResponsiveHelper.width(14),
                        height: ResponsiveHelper.height(14),
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
