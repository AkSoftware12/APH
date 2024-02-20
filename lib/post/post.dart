import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Add to Post'),
            onTap: () {
              // Implement the action you want to perform when "Add to Post" is tapped.
              // For example, you can show a dialog or navigate to another screen.
              Navigator.pop(context); // Close the BottomSheet
            },
          ),
          // Add more ListTile widgets for additional options if needed
        ],
      ),
    );
  }
}