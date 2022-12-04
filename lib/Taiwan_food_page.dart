import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StatefulTaiwanFoodPage extends StatefulWidget {
  const StatefulTaiwanFoodPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return TaiwanFoodPage();
  }
}

class TaiwanFoodPage extends State<StatefulTaiwanFoodPage> {
  List<Image> images = [
    Image.asset('images/1.png'),
    Image.asset('images/2.png'),
    Image.asset('images/3.png'),
    Image.asset('images/4.jpeg'),
  ];

  List<String> ii = [
    'zcbjIjnSN1BlLgaXz6Bi',
    'HheAP6w2MbtSqROjbXOv',
    'hD4NKqXgNlWl0wWS0CLx',
    '拉麵'
  ];

  String currentII = 'zcbjIjnSN1BlLgaXz6Bi';
  Image currentImg = Image.asset('images/1.png');

  Future<void> _launchUrl(uri) async {
    Uri uriToLaunch = Uri.parse(uri);

    if (!await launchUrl(uriToLaunch)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('台式料理'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        shadowColor: const Color.fromARGB(255, 248, 248, 248),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Taiwan Food')
              .doc(currentII)
              .snapshots(),
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              var foodDocument = snapshot.data;
              return Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: <Widget>[
                          currentImg,
                          Text(foodDocument!["name"],
                              style: const TextStyle(fontSize: 25)),
                          Text(foodDocument["calories"],
                              style: const TextStyle(fontSize: 25)),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      OutlinedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          maximumSize: const Size(150, 50),
                        ),
                        child: const Text(
                          '再抽一次',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          setState(() {
                            int index = Random().nextInt(images.length);
                            currentImg = images[index];
                            currentII = ii[index];
                          });
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(150, 50),
                          maximumSize: const Size(150, 50),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          '外送資訊',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _launchUrl(foodDocument["uri"]);
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
            if (snapshot.hasError) {
              return Text('Error = ${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
