import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skyking_tracking/screens/track.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String trackId = null;

  void showSnkBar(BuildContext context){
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Enter Tracking No")
      )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: Image(image: AssetImage("assets/logo.png")),
        title: Center(
          child: Text(
          "SkyKing - Your Delivery Partner",
          style: TextStyle(
            color: Colors.black
          ),
        ),),
        elevation: 0,
        backgroundColor: Colors.grey[350],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          TextFormField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              //icon: Icon(Icons.search),
              //labelText: "Enter Tracking ID",
              hintText: "Enter Tracking ID",

              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onChanged: (text){
              trackId = text;
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
          ),
          CupertinoButton(
            color: Colors.blue,
            child: Text("TRACK"),
            onPressed: () {
              if(trackId != null){
                var route = new MaterialPageRoute(
                  builder: (context) => TrackPage(cnote: trackId)
                );
                Navigator.of(context).push(route);
              }
              // setState(() {
              //   trackId = null;
              // });
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 50)
          ),
          Expanded(
            child: Image(
              image: AssetImage("assets/process.jpg"),
            )
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[350],
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            title: Text("Track")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            title: Text("Branch Locator")
          )
        ],
      ),
    );
  }
}