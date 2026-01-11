import 'package:astrology_app/Routes/routes.dart';
import 'package:astrology_app/views/base/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey,
      width: 2.0,
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Payment",
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios, color: Colors.white,)),),
      body:Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children:[
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
            onCreditCardWidgetChange:
                (CreditCardBrand creditCardBrand) {},
          ),

          const SizedBox(height: 20),
          SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              physics:  const NeverScrollableScrollPhysics(),
              child: Column(
                children:[
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
                      cardHolderTextStyle: const TextStyle(color: Colors.white),
                      cardNumberTextStyle: const TextStyle(color: Colors.white),
                      expiryDateTextStyle: const TextStyle(color: Colors.white),
                      cvvCodeTextStyle: const TextStyle(color: Colors.white),
                      cardHolderDecoration: InputDecoration(
                        labelText: 'Card Holder Name',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      cardNumberDecoration: InputDecoration(
                        labelText: 'Number',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'XXXX XXXX XXXX XXXX',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      expiryDateDecoration:  InputDecoration(
                        labelText: 'Expired Date',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'XX/XX',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      cvvCodeDecoration:  InputDecoration(
                        labelText: 'CVV',
                        labelStyle: TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: 'XXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),

                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomButton(text: "Pay",onpress: _onValidate,),
                ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //_onValidate();
  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
      setState(() {
      Get.toNamed(Routes.singleInfo);
      });
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