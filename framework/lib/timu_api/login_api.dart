import 'dart:convert';
import 'package:http/http.dart' as http;

const String AUTH_BASE_URL = 'https://www.timu.life';

class GetMethodResult {
  GetMethodResult(this.username, this.method, this.provider);

  String username;
  String method;
  String? provider;
}

class VerifyEmailResult {
  VerifyEmailResult(this.flowID, this.token);

  String flowID;
  String token;
}

class LoginApi {
  Future<GetMethodResult?> getMethod(String email) async {
    final response = await http.post(
      Uri.parse('$AUTH_BASE_URL/.ory/kratos/admin/credentials/known'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'identifier': email,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['found'] != null &&
          jsonResponse['found'] &&
          jsonResponse['methods'] != null) {
        final List<dynamic> methods = jsonResponse['methods'];
        if (methods.isNotEmpty) {
          final Map<String, dynamic> first = methods.first;
          final String? method = first['method'];
          if (method != null && method != 'none') {
            final String? username = first['username'];
            if (username != null) {
              if (method == 'password') {
                return GetMethodResult(username, method, null);
              } else if (method == 'oidc') {
                final String? provider = first['provider'];
                if (provider != null) {
                  return GetMethodResult(username, method, provider);
                }
              }
            }
          }
        }
      }

      return null;
    }

    throw Exception('Failed to load data');
  }

  Future<String> initLoginFlow() async {
    final response = await http.get(
        Uri.parse('$AUTH_BASE_URL/.ory/kratos/public/self-service/login/api'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String? id = jsonResponse['id'];
      if (id != null) {
        return id;
      }
    }
    throw Exception('Failed to load data');
  }

  Future<String> initRegistrationFlow() async {
    final response = await http.get(Uri.parse(
        '$AUTH_BASE_URL/.ory/kratos/public/self-service/registration/api'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String? id = jsonResponse['id'];
      if (id != null) {
        return id;
      }
    }
    throw Exception('Failed to load data');
  }

  Future<String> exchangeToken(token) async {
    final response = await http.get(
        Uri.parse('$AUTH_BASE_URL/api/identity/exchange'),
        headers: {'X-Session-Token': token});

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final String? jwt = jsonResponse['token'];
      if (jwt != null) {
        return jwt;
      }
    }
    throw Exception('Failed to load data');
  }

  Future<bool?> isEmailVerified(String jwt) async {
    final response = await http
        .get(Uri.parse('$AUTH_BASE_URL/api/identity/email-verified'), headers: {
      'Authorization': 'Bearer $jwt',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      return jsonResponse['verified'] || false;
    }
    throw Exception('Failed to load data');
  }

  Future<bool> verifyEmailWithCode(
      String jwt, String flowID, String token, String code) async {
    final response = await http.get(
        Uri.parse(
            '$AUTH_BASE_URL/.ory/kratos/public/self-service/verification?flow=$flowID&token=$token&code=$code'),
        headers: {
          // 'Authorization': 'Bearer $jwt',
        });

    if (response.statusCode == 200) {
      // final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // final String? email = jsonResponse['email'];

      return true;
    }
    throw Exception('Failed to load data');
  }

  Future<String> loginPassword(
      String flowID, String username, String password) async {
    final response = await http.post(
      Uri.parse(
          '$AUTH_BASE_URL/.ory/kratos/public/self-service/login?flow=$flowID'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'password',
        'password_identifier': username,
        'password': password,
        // 'csrf_token': null,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['session_token'] != null) {
        return jsonResponse['session_token'];
      }
    }

    throw Exception('Failed to load data');
  }

  Future<String> registerUser(String flowID, String username, String firstName,
      String lastName, String password) async {
    final response = await http.post(
      Uri.parse(
          '$AUTH_BASE_URL/.ory/kratos/public/self-service/registration?flow=$flowID'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'method': 'password',
        'traits.username': username,
        'traits.name.first': firstName,
        'traits.name.last': lastName,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['session_token'] != null) {
        return jsonResponse['session_token'];
      }
    }

    throw Exception('Failed to load data');
  }

  Future<VerifyEmailResult> verifyEmail(String jwt, String email) async {
    final response = await http.post(
      Uri.parse('$AUTH_BASE_URL/api/identity/verify-email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({
        'email': email,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final String? flowID = jsonResponse['flow'];
      final String? token = jsonResponse['token'];

      if (token != null && flowID != null) {
        return VerifyEmailResult(flowID, token);
      }
    }

    throw Exception('Failed to load data');
  }

  Future<void> ramp(String jwt) async {
    final response = await http.post(
      Uri.parse('$AUTH_BASE_URL/api/graph/+onramp'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({
        // firstName: firstName,
        // lastName: lastName,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 400) {
      final String msg = response.body;
      if (msg.contains(RegExp(r'reprovision\s+user'))) {
        return reprovision(jwt);
      } else {
        // error
      }
    }

    throw Exception('Failed to load data');
  }

  Future<void> reprovision(String jwt) async {
    // String jwt, String firstName, String lastName) async {
    final response = await http.post(
      Uri.parse('$AUTH_BASE_URL/api/graph/+reprovision'),
      //api.request(`${apiUrl}/api/graph/+reprovision?access_token=${jwt}`, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwt',
      },
      body: json.encode({
        // 'firstName': firstName,
        // 'lastName': lastName,
      }),
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('Failed to load data');
  }
}
