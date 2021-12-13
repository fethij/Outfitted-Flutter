class Address {
  String name;
  String streetAndNumber;
  String postCode;
  String cityOrTown;
  String phone;
  String country;

  Address(
      {this.name,
      this.streetAndNumber,
      this.postCode,
      this.cityOrTown,
      this.phone,
      this.country});

  Address.getAddressFromJson(Map<String, dynamic> json) {
    name = json['name'];
    streetAndNumber = json['streetAndNumber'];
    postCode = json['postCode'];
    cityOrTown = json['cityOrTown'];
    phone = json['phone'];
    country = json['country'];
  }

  Map<String, dynamic> createAddressToJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['streetAndNumber'] = this.streetAndNumber;
    data['postCode'] = this.postCode;
    data['cityOrTown'] = this.cityOrTown;
    data['phone'] = this.phone;
    data['country'] = this.country;

    return data;
  }
}
