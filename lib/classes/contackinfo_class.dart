import 'dart:convert';

ContactInfo contactInfoFromJson(String str) => ContactInfo.fromJson(json.decode(str));

String contactInfoToJson(ContactInfo data) => json.encode(data.toJson());

class ContactInfo {
    String companyName;
    String branchName;
    String address;
    String contactNo;
    String cityName;
    String pin;
    String eMail;

    ContactInfo({
        this.companyName,
        this.branchName,
        this.address,
        this.contactNo,
        this.cityName,
        this.pin,
        this.eMail,
    });

    factory ContactInfo.fromJson(Map<String, dynamic> json) => ContactInfo(
        companyName: json["CompanyName"],
        branchName: json["BranchName"],
        address: json["Address"],
        contactNo: json["ContactNo"],
        cityName: json["CityName"],
        pin: json["Pin"],
        eMail: json["EMail"],
    );

    Map<String, dynamic> toJson() => {
        "CompanyName": companyName,
        "BranchName": branchName,
        "Address": address,
        "ContactNo": contactNo,
        "CityName": cityName,
        "Pin": pin,
        "EMail": eMail,
    };
}