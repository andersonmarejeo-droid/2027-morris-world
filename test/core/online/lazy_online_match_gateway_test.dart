import 'package:flutter_test/flutter_test.dart';
import 'package:nine_tas/core/online/lazy_online_match_gateway.dart';
import 'package:nine_tas/core/online/online_match_gateway.dart';

void main() {
  test(
    'creates the online service only when availability is requested',
    () async {
      var createCalls = 0;
      final gateway = LazyOnlineMatchGateway(() async {
        createCalls++;
        return const _EnabledGateway();
      });

      expect(createCalls, 0);
      expect((await gateway.availability()).enabled, isTrue);
      expect(createCalls, 1);

      await gateway.availability();
      expect(createCalls, 1);
    },
  );
}

class _EnabledGateway extends DisabledOnlineMatchGateway {
  const _EnabledGateway();

  @override
  Future<OnlineAvailability> availability() async =>
      const OnlineAvailability(enabled: true);
}
