// lib/views/pages/payment_card/payment_card.dart
import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/utils/responsive.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import '../../../utils/color.dart';
import '../../base/custom_button.dart';

class PaymentCard extends StatefulWidget {
  const PaymentCard({super.key});

  @override
  State<PaymentCard> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<PaymentCard> {
  String cardHolderName = '';
  String cardNumber = '';
  String expiryDate = '';

  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Payment",
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.white, size: ResponsiveHelper.iconSize(20)),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CreditCardWidget(
            backgroundImage: 'assets/images/paymentCard.svg',
            cardHolderName: cardHolderName,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cvvCode: cvvCode,
            bankName: 'Visa',
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            cardBgColor: CustomColors.primaryColor,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
          ),

          SizedBox(height: ResponsiveHelper.space(20)),
          SizedBox(height: ResponsiveHelper.space(10)),
          Expanded(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                   // CreditCardForm might have some internal constraints, but we wrap it
                  CreditCardForm(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    formKey: formKey,
                    cardHolderName: cardHolderName,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    expiryDate: expiryDate,
                    inputConfiguration: InputConfiguration(
                      cardHolderTextStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                      cardNumberTextStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                      expiryDateTextStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                      cvvCodeTextStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                      cardHolderDecoration: InputDecoration(
                        labelText: 'Card Holder Name',
                        labelStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        labelStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      expiryDateDecoration: InputDecoration(
                        labelText: 'Expired Date',
                        labelStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                        hintText: 'XX/XX',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      cvvCodeDecoration: InputDecoration(
                        labelText: 'CVV',
                        labelStyle: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.fontSize(14)),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: ResponsiveHelper.fontSize(14)),
                        hintText: 'XXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(ResponsiveHelper.radius(12)),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  SizedBox(height: ResponsiveHelper.space(20)),
                  SizedBox(height: ResponsiveHelper.space(20)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.padding(20)),
                    child: CustomButton(
                      text: "Pay",
                      onpress: _onValidate,
                    ),
                  ),
                  SizedBox(height: ResponsiveHelper.space(20)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      Get.toNamed(Routes.singleInfo);
    } else {
      Get.toNamed(Routes.singleInfo);
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardHolderName = creditCardModel.cardHolderName;
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}