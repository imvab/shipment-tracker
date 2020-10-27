import 'dart:convert';

Checkpoint checkpointFromJson(String str) => Checkpoint.fromJson(json.decode(str));

String checkpointToJson(Checkpoint data) => json.encode(data.toJson());

class Checkpoint {
    String dateTime;
    String cNote;
    String location;
    String status;
    String branchId;
    String locationId;
    dynamic branchName;
    dynamic branchAddress;
    dynamic email;
    dynamic companyName;
    dynamic contactNo;
    dynamic cityName;
    dynamic pinCode;
    String refNo;
    String podImage;
    String statusflag;
    String showPod;
    String bookingImage;

    Checkpoint({
        this.dateTime,
        this.cNote,
        this.location,
        this.status,
        this.branchId,
        this.locationId,
        this.branchName,
        this.branchAddress,
        this.email,
        this.companyName,
        this.contactNo,
        this.cityName,
        this.pinCode,
        this.refNo,
        this.podImage,
        this.statusflag,
        this.showPod,
        this.bookingImage,
    });

    factory Checkpoint.fromJson(Map<String, dynamic> json) => Checkpoint(
        dateTime: json["DateTime"],
        cNote: json["CNote"],
        location: json["Location"],
        status: json["Status"],
        branchId: json["branchID"],
        locationId: json["locationID"],
        branchName: json["branchName"],
        branchAddress: json["branchAddress"],
        email: json["email"],
        companyName: json["companyName"],
        contactNo: json["contactNo"],
        cityName: json["cityName"],
        pinCode: json["PinCode"],
        refNo: json["RefNo"],
        podImage: json["PODImage"],
        statusflag: json["Statusflag"],
        showPod: json["ShowPOD"],
        bookingImage: json["BookingImage"],
    );

    Map<String, dynamic> toJson() => {
        "DateTime": dateTime,
        "CNote": cNote,
        "Location": location,
        "Status": status,
        "branchID": branchId,
        "locationID": locationId,
        "branchName": branchName,
        "branchAddress": branchAddress,
        "email": email,
        "companyName": companyName,
        "contactNo": contactNo,
        "cityName": cityName,
        "PinCode": pinCode,
        "RefNo": refNo,
        "PODImage": podImage,
        "Statusflag": statusflag,
        "ShowPOD": showPod,
        "BookingImage": bookingImage,
    };
}

class Checkpoints{
  final List<Checkpoint> checkpoints;

  Checkpoints({this.checkpoints});

  factory Checkpoints.fromJson(List<dynamic> parsedJson){
    List<Checkpoint> checkpoints = new List<Checkpoint>();

    checkpoints = parsedJson.map((i) => Checkpoint.fromJson(i)).toList();

    return new Checkpoints(checkpoints: checkpoints);
  }
}
