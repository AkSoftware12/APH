import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'add_image.dart';
import 'add_video.dart';

class BottomSheetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      height: 200,
      child: Wrap(
        children: <Widget>[

          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: ListTile(
              leading: Icon(Icons.image_sharp, color: Colors.orangeAccent,),
              title: Text('Add to Image'),
              onTap: () {

                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddImage(type: 'image',);
                    },
                  ),
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.video_collection,color: Colors.orangeAccent,),
            title: Text('Add to Video'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return AddVideo(type: 'video');
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