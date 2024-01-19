import 'package:flutter/material.dart';


class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationItem> notifications = [
    NotificationItem(
      title: "Notification 1",
      subtitle: "This is the first notification",
      time: "10:00 AM",
      imageUrl: 'https://c.saavncdn.com/057/Barse-Re-From-Manush-Hindi-Hindi-2023-20231113122507-500x500.jpg',
    ),
    NotificationItem(
      title: "Notification 2",
      subtitle: "This is the second notification",
      time: "11:30 AM",
      imageUrl:'https://c.saavncdn.com/057/Barse-Re-From-Manush-Hindi-Hindi-2023-20231113122507-500x500.jpg',
    ),
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationListItem(
            notification: notifications[index],
            onTap: () {
              // Handle item click (remove dot)
              setState(() {
                notifications[index].read = true;
              });
            },
          );
        },
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String subtitle;
  final String time;
  final String imageUrl;
  bool read; // Add a property to track if the notification has been read

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.imageUrl,
    this.read = false,
  });
}

class NotificationListItem extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  NotificationListItem({
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: ListTile(
                  onTap: onTap,
                  leading:  SizedBox(
                      width: 35,
                      height: 35,
                      child: Image.network(notification.imageUrl,)),
                  title: Text(notification.title),
                  subtitle: Text(notification.subtitle),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(notification.time),
                      if (!notification.read)
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),


                ),

              ),
              const Divider(
                color: Colors.grey, // Set the color of the divider
                thickness: 1.0, // Set the thickness of the divider
                height: 1, // Set the height of the divider
              ),
            ],
          )
      ),
    );

  }
}

