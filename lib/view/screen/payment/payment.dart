import 'package:ecommercebig/view/screen/home.dart';
import 'package:ecommercebig/view/screen/payment/addpaymentcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentScreenState();
  }
}

class PaymentScreenState extends State<PaymentScreen> {
  String cardNumber = '5555 55555 5555 4444';
  String expiryDate = '12/25';
  String cardHolderName = 'user one';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: InkWell(
            onTap: () {
              Get.to(() => home());
            },
            child: Icon(Icons.arrow_back)),
        title: Text("Your Cards"),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            //greenIntroWidgetWithoutLogos(title: 'My Card'),
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              bottom: 80,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  String cardNumber = '';
                  String expiryDate = '';
                  String cardHolderName = '';
                  String cvvCode = '';

                  try {
                    cardNumber = '1234 1234 1234 1234';
                  } catch (e) {
                    cardNumber = '';
                  }

                  try {
                    expiryDate = '28/04';
                  } catch (e) {
                    expiryDate = '';
                  }

                  try {
                    cardHolderName = 'James Charles';
                  } catch (e) {
                    cardHolderName = '';
                  }

                  try {
                    cvvCode = '697';
                  } catch (e) {
                    cvvCode = '';
                  }

                  return CreditCardWidget(
                    cardBgColor: Colors.black,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cardHolderName: cardHolderName,
                    cvvCode: cvvCode,
                    bankName: '',
                    showBackView: isCvvFocused,
                    obscureCardNumber: true,
                    obscureCardCvv: true,
                    isHolderNameVisible: true,
                    isSwipeGestureEnabled: true,
                    onCreditCardWidgetChange:
                        (CreditCardBrand creditCardBrand) {},
                  );
                },
                itemCount: 4,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 80,
                      width: 200,
                    ),
                    Text(
                      "Add new card",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        // Navigate to AddPaymentCardScreen
                        Get.off(() => AddPaymentCardScreen());
                      },
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget greenIntroWidgetWithoutLogos(
      {String title = "Profile Settings", String? subtitle}) {
    return Container(
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/mask.png'),
          fit: BoxFit.fill,
        ),
      ),
      height: Get.height * 0.3,
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                FloatingActionButton(
                  onPressed: () {
                    // Navigate to AddPaymentCardScreen
                    Get.to(() => home());
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.green,
                ),
              ],
            ),
          ),
          Container(
            height: Get.height * 0.1,
            width: Get.width,
            margin: EdgeInsets.only(bottom: Get.height * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
