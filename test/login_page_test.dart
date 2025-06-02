import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('Login API unit test (frontend)', () {
    test('Login succeeds and returns sessionId', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.toString(), 'http://localhost:3000/login');
        expect(request.method, 'POST');
        final payload = jsonDecode(request.body);
        expect(payload['username'], 'testuser');
        expect(payload['password'], 'testpass');
        return http.Response(jsonEncode({'sessionId': 'xyz123'}), 200);
      });

      final response = await mockClient.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': 'testuser', 'password': 'testpass'}),
      );

      final result = jsonDecode(response.body);
      expect(result['sessionId'], 'xyz123');
    });

    test('Login fails with invalid credentials', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Invalid credentials', 401);
      });

      final response = await mockClient.post(
        Uri.parse('http://localhost:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': 'wronguser', 'password': 'wrongpass'}),
      );

      expect(response.statusCode, 401);
      expect(response.body, 'Invalid credentials');
    });
  });
}
