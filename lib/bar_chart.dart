import 'dart:convert';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';


class Rating {
  var user_id;
  var rating;

  Rating({user_id, rating});

  Rating.fromJson(Map<String, dynamic> json)
      : user_id = json['user_id'],
        rating = json['rating'];
}

class LiveRatingBar extends StatefulWidget {
  const LiveRatingBar({Key? key}) : super(key: key);

  @override
  State<LiveRatingBar> createState() => _LiveRatingBarState();
}

class _LiveRatingBarState extends State<LiveRatingBar> {
  late Socket socket;

  var oneStar = 0;
  var twoStar = 0;
  var threeStar = 0;
  var fourStar = 0;
  var fiveStar = 0;

  socket_io() {
    print("Success");
    socket = io(
        'http://192.168.227.122:3000',
        OptionBuilder().setTransports(['websocket']) // for Flutter or Dart VM
        // .disableAutoConnect()  // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());

    socket.on('total_ratings', (data) {
      // main rating list
      List<dynamic> ratings = data;

      oneStar = 0;
      twoStar = 0;
      threeStar = 0;
      fourStar = 0;
      fiveStar = 0;

      for (var rating in ratings) {
        var userRating = Rating.fromJson(jsonDecode(rating));
        // print('user_id ${userRating.user_id}');
        print('rating ${userRating.rating}');
        print("\n====================================\n");

        switch (userRating.rating) {
          case 1:
            oneStar++;
            break;
          case 2:
            twoStar++;
            break;
          case 3:
            threeStar++;
            break;
          case 4:
            fourStar++;
            break;
          case 5:
            fiveStar++;
            break;
          default:
            break;
        }
      }

      setState(() {

      });
      print("total ratings: ${ratings.length}");
    });
    socket.connect();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socket_io();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Bar Chart'),
        actions: [IconButton(onPressed: () {
          setState(() {
            socket.emit('reset');
          });
        }, icon: Icon(Icons.clear))],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //--[Start]---
            Container(
              height: 700,
              width: 1000,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Padding(
                padding: EdgeInsets.all(40),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: DChartBar(
                    data: [
                      {
                        'id': 'Bar',
                        'data': [
                          {'domain': '⭐', 'measure': oneStar},
                          {'domain': '⭐⭐', 'measure': twoStar},
                          {'domain': '⭐⭐⭐', 'measure': threeStar},
                          {'domain': '⭐⭐⭐⭐', 'measure': fourStar},
                          {'domain': '⭐⭐⭐⭐⭐', 'measure': fiveStar},
                        ],
                      },
                    ],
                    domainLabelPaddingToAxisLine: 20,
                    axisLineTick: 2,
                    axisLinePointTick: 2,
                    axisLinePointWidth: 4,
                    axisLineColor: Colors.green,
                    measureLabelPaddingToAxisLine: 16,
                    barColor: (barData, index, id) => barData['measure'] >= 4
                        ? Colors.green.shade300
                        : Colors.green.shade700,
                    barValue: (barData, index) => '${barData['measure']}',
                    showBarValue: true,
                    barValuePosition: BarValuePosition.auto,
                  ),
                ),
              ),
            ),
            //--[End]---
          ],
        ),
      ),
    );
  }
}
