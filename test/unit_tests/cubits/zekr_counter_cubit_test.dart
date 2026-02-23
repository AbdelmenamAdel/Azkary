// import 'package:flutter_test/flutter_test.dart';
// import 'package:bloc_test/bloc_test.dart';
// import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_cubit.dart';
// import 'package:azkar/features/Azkar/manager/Counter/zekr_counter_state.dart';

// void main() {
//   group('ZekrCounterCubit Tests', () {
//     late ZekrCounterCubit zekrCounterCubit;

//     setUp(() {
//       zekrCounterCubit = ZekrCounterCubit();
//     });

//     tearDown(() {
//       zekrCounterCubit.close();
//     });

//     test('Initial state counter is 0', () {
//       expect(zekrCounterCubit.state.count, equals(0));
//     });

//     blocTest<ZekrCounterCubit, ZekrCounterState>(
//       'emits state with incremented count when increment is called',
//       build: () => zekrCounterCubit,
//       act: (cubit) => cubit.increment(),
//       expect: () => [
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(1),
//         ),
//       ],
//     );

//     blocTest<ZekrCounterCubit, ZekrCounterState>(
//       'emits correct state after multiple increments',
//       build: () => zekrCounterCubit,
//       act: (cubit) {
//         cubit.increment();
//         cubit.increment();
//         cubit.increment();
//       },
//       expect: () => [
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(1),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(2),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(3),
//         ),
//       ],
//     );

//     blocTest<ZekrCounterCubit, ZekrCounterState>(
//       'correctly resets counter to 0',
//       build: () => zekrCounterCubit,
//       act: (cubit) async {
//         cubit.increment();
//         cubit.increment();
//         await cubit.resetCounter();
//       },
//       expect: () => [
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(1),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(2),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(0),
//         ),
//       ],
//     );

//     blocTest<ZekrCounterCubit, ZekrCounterState>(
//       'handles large count values',
//       build: () => zekrCounterCubit,
//       act: (cubit) {
//         for (int i = 0; i < 1000; i++) {
//           cubit.increment();
//         }
//       },
//       verify: (cubit) {
//         expect(cubit.state.count, equals(1000));
//       },
//     );

//     test('increment increases count by exactly 1', () async {
//       final initialCount = zekrCounterCubit.state.count;
//       zekrCounterCubit.increment();

//       await Future.delayed(const Duration(milliseconds: 50));

//       expect(zekrCounterCubit.state.count, equals(initialCount + 1));
//     });
//   });

//   group('ZekrCounterCubit Edge Cases', () {
//     late ZekrCounterCubit zekrCounterCubit;

//     setUp(() {
//       zekrCounterCubit = ZekrCounterCubit();
//     });

//     tearDown(() {
//       zekrCounterCubit.close();
//     });

//     blocTest<ZekrCounterCubit, ZekrCounterState>(
//       'reset works correctly after increments',
//       build: () => zekrCounterCubit,
//       act: (cubit) async {
//         cubit.increment();
//         cubit.increment();
//         await cubit.resetCounter();
//         cubit.increment();
//       },
//       expect: () => [
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(1),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(2),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(0),
//         ),
//         isA<ZekrCounterState>().having(
//           (state) => state.count,
//           'count',
//           equals(1),
//         ),
//       ],
//     );

//     test('counter state is properly emitted after each action', () {
//       final states = <ZekrCounterState>[];

//       final subscription = zekrCounterCubit.stream.listen(states.add);

//       zekrCounterCubit.increment();
//       zekrCounterCubit.increment();

//       expect(states, hasLength(greaterThan(0)));

//       subscription.cancel();
//     });
//   });

//   group('ZekrCounterCubit Performance', () {
//     late ZekrCounterCubit zekrCounterCubit;

//     setUp(() {
//       zekrCounterCubit = ZekrCounterCubit();
//     });

//     tearDown(() {
//       zekrCounterCubit.close();
//     });

//     test('increment completes quickly', () {
//       final stopwatch = Stopwatch()..start();

//       for (int i = 0; i < 100; i++) {
//         zekrCounterCubit.increment();
//       }

//       stopwatch.stop();

//       expect(
//         stopwatch.elapsedMilliseconds,
//         lessThan(1000),
//         reason:
//             'Incrementing 100 times took ${stopwatch.elapsedMilliseconds}ms',
//       );
//     });

//     test('reset completes quickly', () async {
//       // Setup
//       for (int i = 0; i < 100; i++) {
//         zekrCounterCubit.increment();
//       }

//       final stopwatch = Stopwatch()..start();
//       await zekrCounterCubit.resetCounter();
//       stopwatch.stop();

//       expect(
//         stopwatch.elapsedMilliseconds,
//         lessThan(500),
//         reason: 'Reset took ${stopwatch.elapsedMilliseconds}ms',
//       );
//     });
//   });
// }
