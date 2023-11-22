class GPSDetailsModel {
  GPSDetailsModel({
    this.gpsAddress,
    this.latitude,
    this.longitude,
  });
  String? gpsAddress;
  String? latitude;
  String? longitude;

  GPSDetailsModel.fromJson(Map<String, dynamic> json){
    gpsAddress = json['gps_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['gps_address'] = gpsAddress;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}