import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyking_tracking/screens/track.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String trackId = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        //leading: Image(image: AssetImage("assets/delivery_boy.png"), width: 5, height: 5,),
        title: Center(
            child: Text(
          "Track Shipment",
          style: TextStyle(color: Colors.black),
        )),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          Container(
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                //icon: Icon(Icons.search),
                //labelText: "Enter Tracking ID",
                hintText: "Consignment ID",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              style: TextStyle(fontSize: 20),
              onChanged: (text) {
                trackId = text;
              },
            ),
            width: MediaQuery.of(context).size.width * 0.6,
          ), //width: MediaQuery.of(context).size.width * 0.6,),

          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          CupertinoButton(
            color: Colors.blue,
            child: Text("TRACK"),
            onPressed: () {
              if (trackId != null) {
                var route = new MaterialPageRoute(
                    builder: (context) => TrackPage(cnote: trackId));
                Navigator.of(context).push(route);
              }
              // setState(() {
              //   trackId = null;
              // });
            },
          ),

          Padding(padding: EdgeInsets.only(bottom: 50)),

          Expanded(
              child: Image(
            image: AssetImage("assets/process.jpg"),
          ))
        ],
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text("Track")),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city), title: Text("Branch Locator"))
        ],
      ),
    );
  }
}
