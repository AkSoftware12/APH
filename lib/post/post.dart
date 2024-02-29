import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_post_list.dart';

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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddPost();
                  },
                ),
              );
            },
          ),
          // Add more ListTile widgets for additional options if needed
        ],
      ),
    );
  }
}