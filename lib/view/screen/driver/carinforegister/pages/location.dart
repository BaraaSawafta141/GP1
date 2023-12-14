import 'package:flutter/material.dart';

class locationPage extends StatefulWidget {
  locationPage(
      {super.key, required this.selectedLocations, required this.onSelect});
  final String selectedLocations;
  final Function onSelect;
  @override
  State<locationPage> createState() => _nameState();
}

class _nameState extends State<locationPage> {
  List<String> locations = ['Jenin', 'Nablus', 'Ramallah', 'Jerusalem'];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
        Text(
          'What Location Are You Available In ?',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemBuilder: (ctx, i) {
                return ListTile(
                  onTap: () => widget.onSelect(locations[i]),
                  //visualDensity: VisualDensity(vertical: -4),
                  title: Text(
                    locations[i],
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: widget.selectedLocations == locations[i]
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                );
              },
              itemCount: locations.length),
        ),
      ],
    );
  }
}
