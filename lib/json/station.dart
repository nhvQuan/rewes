import 'package:json_annotation/json_annotation.dart';
import 'geolocation.dart';
part 'station.g.dart';

//// decode chuỗi Json bằng class
@JsonSerializable(explicitToJson: true)
class Station {
  Station(this.name, this.geolocation, this.address, this.id);
  late String name;
  late Geolocation geolocation;
  late String address;
  late String id;
  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
  Map<String, dynamic> toJson() => _$StationToJson(this);
}
