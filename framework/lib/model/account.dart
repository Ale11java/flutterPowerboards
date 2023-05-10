class Account {
  Account(
      {required this.key,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.accessToken,
      required this.method,
      required this.provider});

  final String key;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? accessToken;
  final String? method;
  final String? provider;

  static Account fromMapEntry(MapEntry<String, dynamic> entry) {
    final Map<String, dynamic> value = entry.value as Map<String, dynamic>;

    return Account(
      key: entry.key,
      email: value['email'] as String,
      firstName: value['firstName'] as String?,
      lastName: value['lastName'] as String?,
      accessToken: value['access'] as String?,
      method: value['method'] as String?,
      provider: value['provider'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'access': accessToken,
      'method': method,
      'provider': provider,
    };
  }
}

const ProviderGoogle = 'google';
const ProviderMicrosoft = 'microsoft';
const ProviderTimuGuest = 'guest';
