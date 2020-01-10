import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skyking_tracking/classes/consignment_class.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import 'package:skyking_tracking/classes/contackinfo_class.dart';

//387236300

Future fetchPost(String cnote) async {
  final response =
      await http.get('https://live.skyking.co/api/Track/ConsignmentMTrack_Mobile?true&cnote=' + cnote + '&key=skm&Email=skm%40flyking.co.in',
      headers: {"Accept": "application/json"});
  return response.body;
}

Future<List<Checkpoint>> loadCheckpoints(String cnote) async {
  String jsonString = await fetchPost(cnote);
  final jsonResponse = json.decode(jsonString);
  Checkpoints c = Checkpoints.fromJson(jsonResponse);
  return c.checkpoints;
}

Future fetchInfo(String id) async {
  final response =
      await http.get('https://live.skyking.co/FlykingTransaction.asmx/GetBranchDetailsForTrack?ID=' + id,
      headers: {"Accept": "application/json"});
  //print(response.body);
  return response.body;
}

Future<ContactInfo> loadInfo(String id) async {
  String jsonString = await fetchInfo(id);
  final jsonResponse = json.decode(jsonString);
  
  ContactInfo info = ContactInfo.fromJson(jsonResponse[0]);
  return info;
}

Future podLink(String id) async {
  final response =
      await http.get('https://live.skyking.co/api/values/TrachPdfDisplay?vchDRSNo=' + id,
      headers: {"Accept": "application/json"});
  final jsonResponse = json.decode(response.body);
  return jsonResponse[0]["DRS_ScanCopy"];
}




class TrackPage extends StatefulWidget {
  final String cnote;

  TrackPage({this.cnote});

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  int _current = 0;

  void showpdf(String pod) async {
    print(pod);
    String s = await podLink(pod);
    launch("https://s3-ap-southeast-1.amazonaws.com/scancopyofdrs/" + s);
  }

  Widget makeDialog(String id) {
    return FutureBuilder(
      future: loadInfo(id),
      builder: (context, snapshot){
        return AlertDialog(
          elevation: 0,
          title: Center(child: Text("Contact Info")),
          content: snapshot.hasData ?
          Container(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CupertinoButton(
                color: Colors.green[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, 
                    color: Colors.black), 
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text("Open In Maps", 
                      style: TextStyle(color: Colors.black, fontSize: 14), 
                    )
                  ]
                ),
                onPressed: () => launch("https://www.google.com/maps/search/?api=1&query=" + snapshot.data.address),
              ),
              CupertinoButton(
                color: Colors.blue[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.call, color: Colors.black), 
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(snapshot.data.contactNo.split(" ")[0], 
                      style: TextStyle(color: Colors.black, fontSize: 14)
                    )
                  ],
                ),
                onPressed: () => launch("tel:" + snapshot.data.contactNo.split(" ")[0]),
              ),
              CupertinoButton(
                color: Colors.blue[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.call, color: Colors.black), 
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text(snapshot.data.contactNo.split(" ")[1], 
                      style: TextStyle(color: Colors.black, fontSize: 14)
                    )
                  ],
                ),
                onPressed: () => launch("tel:" + snapshot.data.contactNo.split(" ")[1]),
              ),
              CupertinoButton(
                color: Colors.red[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.mail_outline, 
                    color: Colors.black), 
                    Padding(padding: EdgeInsets.only(left: 5)),
                    Text("Email", 
                      style: TextStyle(color: Colors.black, fontSize: 14)
                    )
                  ]
                ),
                onPressed: () => launch("mailto:" + snapshot.data.eMail),
              ),
            ]
          ), height: 300)
          : LinearProgressIndicator(),
        );
      },
    );
  }

  List<Step> getSteps(BuildContext context, AsyncSnapshot snapshot)  {
    List<Step> steps = [];
    
    for(int i = 0; i < snapshot.data.length; i++){
      Step s = Step(
        title: Container(
          child: Text(
            snapshot.data[i].status
          ),
          width: MediaQuery.of(context).size.width * 0.75
        ),
        subtitle: Text("Time: " + snapshot.data[i].dateTime),
        isActive: true, 

        content: Container(
          child: Column(
            children: <Widget>[
              Text(
                "Location: " + snapshot.data[i].location + "\n",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
              CupertinoButton(
                color: Colors.grey[350],
                child: Text("View Details", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  showDialog(
                    context: context,
                    child: snapshot.data[i].branchId == "0" ?
                    AlertDialog(title: Text("Conact Info"), content: Text("Info Not Available"),)
                    : makeDialog(snapshot.data[i].branchId)
                  );
                },
              ),
            ],
          )
        )
      );
      steps.add(s);
    }
    return steps;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      /*
      appBar: AppBar(
        title: Text("Tracking")
      ),
      */
      appBar: AppBar(
        title: Text("Tracking Results", style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: FutureBuilder<List<Checkpoint>>(
        future: loadCheckpoints(widget.cnote),
        builder: (context, snapshot){
          if(snapshot.hasData){
            int len = snapshot.data.length;
            String s = snapshot.data[len - 1].statusflag;
            if(len == 0){
              return Center(child: Image(image: AssetImage("assets/404.jpg")));

            }else{
              if(s == "1"){
                return Column(
                  children: <Widget>[
                    Container(
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[Text("DELIVERED"), CupertinoButton(
                        child: Text("View POD", style: TextStyle(color: Colors.black),),
                        color: Colors.blue[100],
                        onPressed: () => showpdf(snapshot.data[len - 1].refNo),
                      ),]
                    ),),
                    Stepper(
                      steps: getSteps(context, snapshot),
                      currentStep: _current,
                      controlsBuilder: (context, {onStepContinue, onStepCancel}){
                        return Row();
                      },
                      onStepTapped: (int i) {
                        setState(() {
                          _current = i;
                        });
                      },
                    )
                  ],
                );
              }else{
                return Stepper(
                  steps: getSteps(context, snapshot),
                  currentStep: _current,
                  controlsBuilder: (context, {onStepContinue, onStepCancel}){
                    return Row();
                  },
                  onStepTapped: (int i) {
                    setState(() {
                      _current = i;
                    });
                  },
                );
              }
            }
          }else{
            return LinearProgressIndicator();
          }
        }
      ),
    );
  }
}