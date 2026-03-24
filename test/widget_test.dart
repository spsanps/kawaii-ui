import 'package:flutter_test/flutter_test.dart';
import 'package:kawaii_ui/kawaii_ui.dart';

void main() {
  test('Library exports', () {
    // Verify core types are accessible
    expect(KawaiiColors.pinkBottom, isNotNull);
    expect(KawaiiSpacing.md, equals(8));
    expect(KawaiiBorderRadius.card, equals(22));
  });
}
