import 'package:cobra_shield/services/url_cleaner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UrlCleaner', () {
    test('يحذف معاملات التتبع المعروفة ويحافظ على بقية الاستعلام والمسار', () {
      final result = UrlCleaner.clean(
        'https://example.com/path?utm_source=mail&fbclid=abc&keep=a%2Fb#section',
      );
      expect(result.valid, isTrue);
      expect(result.removed, containsAll(<String>['utm_source', 'fbclid']));
      expect(
        result.cleaned,
        'https://example.com/path?keep=a%2Fb#section',
      );
    });

    test('لا يحذف المعامل العام ref لأنه قد يحمل معنى وظيفيًا', () {
      final result = UrlCleaner.clean(
        'https://example.com/item?ref=order-123&utm_campaign=spring',
      );
      expect(result.valid, isTrue);
      expect(result.removed, <String>['utm_campaign']);
      expect(result.cleaned, 'https://example.com/item?ref=order-123');
    });

    test('يتعرف على اسم معامل تتبع مرمّز قبل إزالته', () {
      final result = UrlCleaner.clean(
        'https://example.com/?utm%5Fsource=mail&safe=1',
      );
      expect(result.removed, <String>['utm_source']);
      expect(result.cleaned, 'https://example.com/?safe=1');
    });

    test('يرفض النص الذي لا يحتوي مضيفًا', () {
      final result = UrlCleaner.clean('not a url');
      expect(result.valid, isFalse);
      expect(result.cleaned, 'not a url');
      expect(result.removed, isEmpty);
    });
  });
}
