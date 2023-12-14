import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VehicalModelYearPage extends StatefulWidget {
  VehicalModelYearPage({Key? key, required this.onSelect}) : super(key: key);

  final Function onSelect;

  @override
  State<VehicalModelYearPage> createState() => _VehicalModelYearPageState();
}

class _VehicalModelYearPageState extends State<VehicalModelYearPage> {
  List<int> years = [
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
    2021,
    2022,
    2023,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'What is the vehicle model year ?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: Center(
          child: CupertinoPicker.builder(
            childCount: years.length,
            itemBuilder: (BuildContext context, int index) {
              return Center(
                  child: Text(
                years[index].toString(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ));
            },
            itemExtent: 50,
            onSelectedItemChanged: (value) {
              widget.onSelect(years[value]);
            },
          ),
        )),
      ],
    );
  }
}
