import 'package:lottie/lottie.dart';

class OnBoardingModel {
  final String? title;
  final String? image;
  final String? body;
  OnBoardingModel({this.body, this.title, this.image});
  @override
  String toString() {
    return '$image';
  }
}
