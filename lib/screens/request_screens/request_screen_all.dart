import 'package:flutter/material.dart';

import '../../variables.dart';

class RequestAll extends StatefulWidget {
  const RequestAll({super.key});
  @override
  State<RequestAll> createState() => _RequestAll();
}

class _RequestAll extends State<RequestAll> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        const ListTile(
          title: Text('Report 1'),
          subtitle: Text('Supporting text'),
        ),
        Divider(height: 0, color: theme_color),
        const ListTile(
          title: Text('Reprot 2'),
          subtitle: Text(
              'Longer supporting text to demonstrate how the text wraps and how the leading and trailing widgets are centered vertically with the text.'),
        ),
        Divider(height: 0, color: theme_color),
        const ListTile(
          title: Text('Report 3'),
          subtitle: Text(
              "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
        ),
        Divider(height: 0, color: theme_color),
        const ListTile(
          //  leading: CircleAvatar(child: Text('C')),
          title: Text('Report 3'),
          subtitle: Text(
              "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
        ),
        Divider(height: 0, color: theme_color),
        const ListTile(
          title: Text('Report 3'),
          subtitle: Text(
              "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
        ),
        Divider(height: 0, color: theme_color),
        const ListTile(
          title: Text('Report 3'),
          subtitle: Text(
              "Longer supporting text to demonstrate how the text wraps and how setting 'ListTile.isThreeLine = true' aligns leading and trailing widgets to the top vertically with the text."),
        ),
        Divider(height: 0, color: theme_color),
      ],
    );
  }
}
