// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      json['name'] as String,
      Geolocation.fromJson(json['geolocation'] as Map<String, dynamic>),
      json['address'] as String,
      json['id'] as String,
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'name': instance.name,
      'geolocation': instance.geolocation.toJson(),
      'address': instance.address,
      'id': instance.id,
    };
