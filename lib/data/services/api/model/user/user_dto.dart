class UserDto {
  final int id;
  final String email;
  final String username;
  final NameDto name;
  final AddressDto address;
  final String phone;

  UserDto.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      email = json['email'],
      username = json['username'],
      name = NameDto.fromJson(json['name']),
      address = AddressDto.fromJson(json['address']),
      phone = json['phone'];
}

class NameDto {
  final String firstname;
  final String lastname;

  NameDto.fromJson(Map<String, dynamic> json)
    : firstname = json['firstname'],
      lastname = json['lastname'];
}

class AddressDto {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeolocationDto geolocation;

  AddressDto.fromJson(Map<String, dynamic> json)
    : city = json['city'],
      street = json['street'],
      number = json['number'],
      zipcode = json['zipcode'],
      geolocation = GeolocationDto.fromJson(json['geolocation']);
}

class GeolocationDto {
  final String lat;
  final String long;

  GeolocationDto.fromJson(Map<String, dynamic> json)
    : lat = json['lat'],
      long = json['long'];
}
