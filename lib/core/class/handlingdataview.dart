import 'package:ecommercebig/core/class/statusrequest.dart';
import 'package:ecommercebig/core/constant/imageasset.dart';
import 'package:ecommercebig/linkapi.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class handlingdataview extends StatelessWidget {
  final statusrequest statusreq;
  final Widget widget;

  const handlingdataview(
      {super.key, required this.statusreq, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusreq == statusrequest.loading
        ?  Center(
            child: Lottie.asset(AppImageAsset.loading))
        : statusreq == statusrequest.offlineFailure
            ?  Center(
                child: Lottie.asset(AppImageAsset.offline))
            : statusreq == statusrequest.serverFailure
                ?  Center(
                    child: Lottie.asset(applink.server))
                : statusreq == statusrequest.failure
                    ?  Center(
                        child: Lottie.asset(AppImageAsset.nodata))
                    : widget;
  }
}

class handlingdatarequest extends StatelessWidget {
  final statusrequest statusreq;
  final Widget widget;

  const handlingdatarequest(
      {super.key, required this.statusreq, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusreq == statusrequest.loading
        ?  Center(
            child: Lottie.asset(AppImageAsset.loading))
        : statusreq == statusrequest.offlineFailure
            ?  Center(
                child: Lottie.asset(AppImageAsset.offline))
            : statusreq == statusrequest.serverFailure
                ?  Center(
                    child: Lottie.asset(applink.server))
                :  widget;
  }
}
