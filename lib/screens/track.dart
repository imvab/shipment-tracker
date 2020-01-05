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
  //print(jsonResponse);
  Checkpoints c = Checkpoints.fromJson(jsonResponse);
  return c.checkpoints;
}

Future fetchInfo(String id) async {
  final response =
      await http.get('https://live.skyking.co/FlykingTransaction.asmx/GetBranchDetailsForTrack?ID=' + id,
      headers: {"Accept": "application/json"});
  return response.body;
}

Future<ContactInfo> loadInfo(String id) async {
  String jsonString = await fetchInfo(id);
  final jsonResponse = json.decode(jsonString);
  
  ContactInfo info = ContactInfo.fromJson(jsonResponse[0]);
  return info;
}




class TrackPage extends StatefulWidget {
  final String cnote;

  TrackPage({this.cnote});

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  int _current = 0;

  Widget makeDialog(String id) {
    return FutureBuilder(
      future: loadInfo(id),
      builder: (context, snapshot){
        return AlertDialog(
          title: Text("Contact Info"),
          content: snapshot.hasData ?
          Container(child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                "Contact No: " + snapshot.data.contactNo + "\n" + 
                "Email: " + snapshot.data.eMail + "\n" +
                "Address: " + snapshot.data.cityName
              ),
              Padding(padding: EdgeInsets.only(bottom: 20)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RawMaterialButton(
                    child: Icon(Icons.call),
                    onPressed: () => launch("tel:" + snapshot.data.contactNo.split(" ")[0]),
                    shape: CircleBorder(),
                    fillColor: Colors.blue,
                    constraints: BoxConstraints(minHeight: 60, minWidth: 60),
                  ),
                  RawMaterialButton(
                    child: Icon(Icons.call),
                    onPressed: () => launch("tel:" + snapshot.data.contactNo.split(" ")[1]),
                    shape: CircleBorder(),
                    fillColor: Colors.cyan,
                    constraints: BoxConstraints(minHeight: 60, minWidth: 60),
                  ),
                ]
              )
            ]
          ),height: 200,)
          : LinearProgressIndicator(),
        );
      },
    );
  }

  List<Step> getSteps(BuildContext context, AsyncSnapshot snapshot) {
    List<Step> steps = [];
    for(int i = 0; i < snapshot.data.length; i++){
      Step s = Step(
        title: Container(
          child: Text(
            snapshot.data[i].status.startsWith("Out For Delivery") 
            ? "Out For Delivery"
            : snapshot.data[i].status,
            overflow: TextOverflow.ellipsis,
          ),
          width: MediaQuery.of(context).size.width * 0.7
        ),
        subtitle: Text("Time :" + snapshot.data[i].dateTime),
        isActive: true, 

        content: Container(
          child: Column(
            children: <Widget>[
              Text(
                "Location :" + snapshot.data[i].location + "\n",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                )
              ),
              CupertinoButton(
                color: Colors.grey[200],
                child: Text("View Details", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  showDialog(
                    context: context,
                    child: snapshot.data[i].branchId == "0" ?
                    AlertDialog(title: Text("Conact Info"), content: Text("Info Not Available"),)
                    : makeDialog(snapshot.data[i].branchId)
                  );
                },
              )
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
        backgroundColor: Colors.grey[300],
        iconTheme: IconThemeData(
          color: Colors.black
        ),
      ),
      body: FutureBuilder<List<Checkpoint>>(
        future: loadCheckpoints(widget.cnote),
        builder: (context, snapshot){
          if(snapshot.hasData){
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
          }else{
            return LinearProgressIndicator();
          }
        }
      ),
    );
  }
}