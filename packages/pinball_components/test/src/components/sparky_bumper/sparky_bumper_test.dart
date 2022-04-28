// ignore_for_file: cascade_invocations

import 'package:bloc_test/bloc_test.dart';
import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pinball_components/pinball_components.dart';
import 'package:pinball_components/src/components/sparky_bumper/behaviors/behaviors.dart';

import '../../../helpers/helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final assets = [
    Assets.images.sparky.bumper.a.active.keyName,
    Assets.images.sparky.bumper.a.inactive.keyName,
    Assets.images.sparky.bumper.b.active.keyName,
    Assets.images.sparky.bumper.b.inactive.keyName,
    Assets.images.sparky.bumper.c.active.keyName,
    Assets.images.sparky.bumper.c.inactive.keyName,
  ];
  final flameTester = FlameTester(() => TestGame(assets));

  group('SparkyBumper', () {
    flameTester.test('"a" loads correctly', (game) async {
      final sparkyBumper = SparkyBumper.a();
      await game.ensureAdd(sparkyBumper);
      expect(game.contains(sparkyBumper), isTrue);
    });

    flameTester.test('"b" loads correctly', (game) async {
      final sparkyBumper = SparkyBumper.b();
      await game.ensureAdd(sparkyBumper);
      expect(game.contains(sparkyBumper), isTrue);
    });

    flameTester.test('"c" loads correctly', (game) async {
      final sparkyBumper = SparkyBumper.c();
      await game.ensureAdd(sparkyBumper);
      expect(game.contains(sparkyBumper), isTrue);
    });

    // TODO(alestiago): Consider refactoring once the following is merged:
    // https://github.com/flame-engine/flame/pull/1538
    // ignore: public_member_api_docs
    flameTester.test('closes bloc when removed', (game) async {
      final bloc = MockSparkyBumperCubit();
      whenListen(
        bloc,
        const Stream<SparkyBumperState>.empty(),
        initialState: SparkyBumperState.active,
      );
      when(bloc.close).thenAnswer((_) async {});
      final sparkyBumper = SparkyBumper.test(bloc: bloc);

      await game.ensureAdd(sparkyBumper);
      game.remove(sparkyBumper);
      await game.ready();

      verify(bloc.close).called(1);
    });

    group('adds', () {
      flameTester.test('new children', (game) async {
        final component = Component();
        final sparkyBumper = SparkyBumper.a(
          children: [component],
        );
        await game.ensureAdd(sparkyBumper);
        expect(sparkyBumper.children, contains(component));
      });

      flameTester.test('a SparkyBumperBallContactBehavior', (game) async {
        final sparkyBumper = SparkyBumper.a();
        await game.ensureAdd(sparkyBumper);
        expect(
          sparkyBumper.children
              .whereType<SparkyBumperBallContactBehavior>()
              .single,
          isNotNull,
        );
      });
    });
  });
}