
final class IpModel{
  final String? ip;
  final String? country;
  final String? cc;



  IpModel({this.ip,this.country,this.cc});

  factory IpModel.fromJson(Map<String, dynamic> json) {
    return IpModel(
      ip: json['ip'] as String?,
      country: json['country'] as String?,
      cc: json['cc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ip': ip,
      'country': country,
      'cc': cc,
    };
  }
}