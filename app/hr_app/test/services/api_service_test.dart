import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:hr_app/services/api_service.dart';
import 'package:hr_app/models/user_model.dart';
import 'package:hr_app/models/leave_model.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = ApiService('test_token')..client = mockClient;
    });

    test('getCurrentUser - success', () async {
      when(mockClient.get(
        Uri.parse('https://your-api-url.com/api/v1/users/me'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '{"id": "1", "email": "test@example.com", "fullName": "Test User", "role": "EMPLOYEE"}',
        200,
      ));

      final user = await apiService.getCurrentUser();

      expect(user, isA<User>());
      expect(user?.id, '1');
      expect(user?.email, 'test@example.com');
    });

    test('getPendingLeaves - success', () async {
      when(mockClient.get(
        Uri.parse('https://your-api-url.com/api/v1/leaves?status=Pending'),
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response(
        '[{"id": "1", "employeeName": "John Doe", "leaveType": "Annual", "startDate": "2023-01-01", "endDate": "2023-01-05", "status": "Pending", "reason": "Vacation"}]',
        200,
      ));

      final leaves = await apiService.getPendingLeaves();

      expect(leaves.length, 1);
      expect(leaves[0].employeeName, 'John Doe');
      expect(leaves[0].leaveType, 'Annual');
    });

    test('updateLeaveStatus - success', () async {
      when(mockClient.put(
        Uri.parse('https://your-api-url.com/api/v1/leaves/1/status'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('', 200));

      final result = await apiService.updateLeaveStatus('1', true);

      expect(result, true);
    });

    test('handle errors gracefully', () async {
      when(mockClient.get(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 500));

      expect(() async => await apiService.getCurrentUser(),
          throwsA(isA<Exception>()));
    });
  });
}