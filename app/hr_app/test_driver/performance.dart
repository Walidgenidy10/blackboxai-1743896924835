import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  tearDownAll(() async {
    await driver.close();
  });

  test('Login screen performance', () async {
    final timeline = await driver.traceAction(() async {
      await driver.tap(find.byValueKey('email'));
      await driver.enterText('test@example.com');
      await driver.tap(find.byValueKey('password'));
      await driver.enterText('password123');
      await driver.tap(find.text('Login'));
      await driver.waitFor(find.byValueKey('dashboard'));
    });

    final summary = TimelineSummary.summarize(timeline);
    await summary.writeTimelineToFile('login_performance', pretty: true);
  });
}