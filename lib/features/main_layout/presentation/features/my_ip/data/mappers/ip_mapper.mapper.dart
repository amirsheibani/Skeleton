// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'ip_mapper.dart';

// **************************************************************************
// MapperGenerator
// **************************************************************************

class IpMapperImpl extends IpMapper {
  @override
  IpEntity entityMapper(IpModel value) {
    return IpEntity(ip: value.country, country: value.ip, cc: value.cc);
  }

  @override
  IpModel modelMapper(IpEntity value) {
    return IpModel(
      ip: value.ip,
      country: value.country?.toUpperCase(),
      cc: value.cc,
    );
  }
}
