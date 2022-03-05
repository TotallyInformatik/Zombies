import 'package:cod_zombies_2d/datastructures/circular_linked_list.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_tnt.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/easteregg/skull_area.dart';
import 'package:flame/components.dart';

import 'datastructures/list_node.dart';

class RoundsManager extends Component with HasGameRef<ZombiesGame> {

  static int hpIncreaseOn = 5;
  static int hardMaxZombieCountCap = 5;
  static CircularLinkedList<ListNode<ZombieTypes>> zombiesList =
    CircularLinkedList<ListNode<ZombieTypes>>(ListNode(ZombieTypes.NORMAL))
      ..addNode(ListNode(ZombieTypes.ICE))
      ..addNode(ListNode(ZombieTypes.BIG))
      ..addNode(ListNode(ZombieTypes.SMOLL));

  int zombieHPIncrease = 0;

  int dynamicMaxZombieCountCap = 2;
  int currentZombieCount = 0;

  int currentRound = 1;
  int requiredKillsInCurrentRound = 10;
  int zombiesKilledInCurrentRound = 0;

  int easterEggTriggerRound = 2;

  ListNode<ZombieTypes> currentZombieType = zombiesList.first; // every round, there should be different zombies

  @override
  Future<void>? onLoad() {
    gameRef.ui.updateRound(0);
    Future.delayed(const Duration(seconds: 1))
        .then((value) => gameRef.ui.updateRound(1));
    return super.onLoad();
  }

  killZombie() {
    zombiesKilledInCurrentRound++;
    currentZombieCount--;
    if (zombiesKilledInCurrentRound > requiredKillsInCurrentRound) {
      newRound();
    }
  }

  newRound() {

    if (currentRound >= easterEggTriggerRound) {
      gameRef.ui.updateEasterEggDisplay("You feel the urge to leave...").then((value)
        => gameRef.ui.updateEasterEggDisplay("NOW!"));
      easterEggNewRound();
    } else {
      standardNewRound();
    }

  }

  standardNewRound() {
    currentRound++;
    gameRef.ui.updateRound(currentRound);
    zombiesKilledInCurrentRound = 0;
    currentZombieCount = 0;
    currentZombieType = currentZombieType.next;
    requiredKillsInCurrentRound += 2;

    if (dynamicMaxZombieCountCap < hardMaxZombieCountCap) {
      dynamicMaxZombieCountCap++;
    }

    if (currentRound % hpIncreaseOn == 0) { /// every fifth round, the hp of zombies increase by one
      zombieHPIncrease++;
    }
  }

  easterEggNewRound() {
    gameRef.ui.updateRound(currentRound);
    zombiesKilledInCurrentRound = 0;
    currentZombieCount = 0;
    currentZombieType = ListNode(ZombieTypes.TNT);
    requiredKillsInCurrentRound = 20;
    dynamicMaxZombieCountCap = 6;
  }

}