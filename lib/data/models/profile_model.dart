class UserProfile {
  final int id;
  final String? name;
  final String? email;
  final bool? isVerified;
  final String? dateJoined;
  final Profile? profile;

  UserProfile({
    required this.id,
    this.name,
    this.email,
    this.isVerified,
    this.dateJoined,
    this.profile,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isVerified: json['is_verified'],
      dateJoined: json['date_joined'],
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "is_verified": isVerified,
      "date_joined": dateJoined,
      "profile": profile?.toJson(),
    };
  }
}

class Profile {
  final int id;
  final String? profilePicture;
  final String? dateOfBirth;
  final String? timeOfBirth;
  final String? birthCountry;
  final String? birthCity;
  final String? createdAt;
  final String? updatedAt;

  Profile({
    required this.id,
    this.profilePicture,
    this.dateOfBirth,
    this.timeOfBirth,
    this.birthCountry,
    this.birthCity,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      profilePicture: json['profile_picture'],
      dateOfBirth: json['date_of_birth'],
      timeOfBirth: json['time_of_birth'],
      birthCountry: json['birth_country'],
      birthCity: json['birth_city'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "profile_picture": profilePicture,
      "date_of_birth": dateOfBirth,
      "time_of_birth": timeOfBirth,
      "birth_country": birthCountry,
      "birth_city": birthCity,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
