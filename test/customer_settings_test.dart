import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/customer_settings.dart';

void main() {
  test('CustomerSettings have default values', () {
    const CustomerSettings settings = CustomerSettings();
    expect(settings.address, isEmpty);
    expect(settings.email, isEmpty);
    expect(settings.patronNo, '');
    expect(settings.receiveNews, isFalse);
  });

  test('CustomerSettings stores set values', () {
    const CustomerSettings settings = CustomerSettings(
      address: '3, Hampton Lake Estate, Chevron Drive',
      email: 'Sucros1245@gmail.com',
      patronNo: '263543',
      receiveNews: true,
    );

    expect(settings.address, '3, Hampton Lake Estate, Chevron Drive');
    expect(settings.email, 'Sucros1245@gmail.com');
    expect(settings.patronNo, '263543');
    expect(settings.receiveNews, true);
  });
}
