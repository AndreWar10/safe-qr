import 'package:safe_qr_back/domain/services/qr_analyzer.dart';
import 'package:test/test.dart';

void main() {
  late QrAnalyzer analyzer;

  setUp(() {
    analyzer = QrAnalyzer();
  });

  test('returns invalid report when payload is empty', () {
    final result = analyzer.analyze('   ');

    expect(result.isSafe, isFalse);
    expect(result.verdict, 'invalid');
  });

  test('flags suspicious link shorteners', () {
    final result = analyzer.analyze('https://bit.ly/some-link');

    expect(result.isSafe, isFalse);
    expect(result.riskScore, greaterThanOrEqualTo(25));
  });

  test('recognizes safe https url', () {
    final result = analyzer.analyze('https://www.microsoft.com/security');

    expect(result.isSafe, isTrue);
    expect(result.verdict, 'trusted');
  });
}
