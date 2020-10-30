import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Color firstPlaceColor = Color(0xffF4C852),
      secondPlaceColor = Color(0xff949494),
      thirdPlaceColor = Color(0xff74380E),
      defaultColor = Color(0xff8BACBF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leader Board"),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {}),
      ),
      backgroundColor: Colors.black,
      body: Container(
        child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Divider(
                  color: firstPlaceColor,
                  height: 5,
                  thickness: 3.0,
                ),
                Card(
                  color: Colors.black,
                  child: ListTile(
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: index == 0
                              ? firstPlaceColor
                              : index == 1
                                  ? secondPlaceColor
                                  : index == 2 ? thirdPlaceColor : defaultColor,
                        ),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.black,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              // index == 0 ? '1' : index == 1 ? '2' :
                              '${index + 1}',
                              style: TextStyle(fontSize: 20),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      'Hero Name',
                      style: TextStyle(
                        color: index == 0
                            ? firstPlaceColor
                            : index == 1
                                ? secondPlaceColor
                                : index == 2 ? thirdPlaceColor : defaultColor,
                      ),
                    ),
                    subtitle: Text(
                      '20',
                      style: TextStyle(
                        color: index == 0
                            ? firstPlaceColor
                            : index == 1
                                ? secondPlaceColor
                                : index == 2 ? thirdPlaceColor : defaultColor,
                      ),
                    ),
                    trailing: Icon(
                      Icons.verified_user,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
