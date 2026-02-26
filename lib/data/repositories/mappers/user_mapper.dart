import 'package:flutter_ecommerce/data/services/api/model/user/user_dto.dart';

import '../../../domain/models/user.dart';

abstract class UserMapper {
  static User toDomain(UserDto dto) {
    return User(
      id: dto.id,
      email: dto.email,
      username: dto.username,
      name: Name(firstname: dto.name.firstname, lastname: dto.name.lastname),
      address: Address(
        city: dto.address.city,
        street: dto.address.street,
        number: dto.address.number,
        zipcode: dto.address.zipcode,
        geolocation: Geolocation(
          lat: dto.address.geolocation.lat,
          long: dto.address.geolocation.long,
        ),
      ),
      phone: dto.phone,
    );
  }
}
