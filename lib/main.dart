import 'package:flutter/material.dart';

import 'bar_chart.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiveRatingBar(),
    );
  }
}
