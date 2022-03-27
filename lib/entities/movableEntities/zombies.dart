import 'package:cod_zombies_2d/datastructures/list_node.dart';
import 'package:cod_zombies_2d/datastructures/queue.dart';
import 'package:cod_zombies_2d/datastructures/stack.dart' as DataStack;
import 'package:cod_zombies_2d/entities/movableEntities/movable_entity.dart';
import 'package:cod_zombies_2d/entities/movableEntities/player.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_big.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_ice.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_small.dart';
import 'package:cod_zombies_2d/entities/movableEntities/zombies/zombies_tnt.dart';
import 'package:cod_zombies_2d/entities/wall.dart';
import 'package:cod_zombies_2d/game.dart';
import 'package:cod_zombies_2d/maps/door/door.dart';
import 'package:cod_zombies_2d/maps/pathfinding/roomArea.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/cupertino.dart';

enum ZombieTypes {
  NORMAL,
  BIG,
  SMOLL,
  ICE,
  TNT
}

getZombieFromZombieType(double srcX, double srcY, ZombieTypes zombieType, int damageAdd, RoomArea roomArea) {

  switch (zombieType) {

    case ZombieTypes.NORMAL:
      return Zombie(srcX, srcY, 3 + damageAdd, roomArea);
    case ZombieTypes.BIG:
      return ZombieBig(srcX, srcY, 5 + damageAdd, roomArea);
    case ZombieTypes.SMOLL:
      return ZombieSmall(srcX, srcY, 2 + damageAdd, roomArea);
    case ZombieTypes.ICE:
      return ZombieIce(srcX, srcY, 3 + damageAdd, roomArea);
    case ZombieTypes.TNT:
      return ZombieTNT(srcX, srcY, roomArea);
  }

}

class Zombie extends SpriteAnimationComponent with HasHitboxes, Collidable, HasGameRef<ZombiesGame>, MoveableEntity {

  final double movementSpeed = 50;
  RoomArea currentRoomArea;

  int hp;
  late DataStack.Stack<RoomArea> pathStack;

  Zombie(srcX, srcY, this.hp, this.currentRoomArea) :
    super(
      position: Vector2(
        srcX,
        srcY
      ),
      size: Vector2(20, 20),
    );

  @override
  Future<void>? onLoad() async {
    await setupAnimations();

    anchor = Anchor.center;
    addHitbox(HitboxCircle());
    updatePath();
    return super.onLoad();
  }

  @override
  void update(double dt) {

    followPlayer(dt);

    if (distance(gameRef.player) < 17) {
      gameRef.player.processHit(1);
    }

    super.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {

    if (other is Wall || other is Door) {
      handleImmovableCollision(intersectionPoints);
    }

    super.onCollision(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(Collidable other) {

    if (other is RoomArea) {
      currentRoomArea = other;
    }

    super.onCollisionEnd(other);

  }

  @override
  void processHit(int dHealth) {
    Player player = gameRef.player;
    hp -= dHealth * player.playerDamageFactor;
    player.changePoints(Player.hitPointIncrease);
    position += (player.position - position).normalized() * -5;
    if (hp <= 0) {
      removeOneself();
    }
  }

  void removeOneself() {
    gameRef.remove(this);
    gameRef.allZombies.remove(this);
    gameRef.roundsManager.killZombie();
  }

  Map<RoomArea, RoomArea?> findPath() {

    /// Breitensuche
    RoomArea playerRoom = gameRef.player.currentRoomArea; /// Ziel

    Queue<RoomArea> frontier = Queue<RoomArea>();
    frontier.enqueue(currentRoomArea);
    Map<RoomArea, RoomArea?> cameFrom = {};
    cameFrom[currentRoomArea] = null;

    while (!frontier.empty()) {
      Node<RoomArea>? current = frontier.dequeue();

      if (current!.content == playerRoom) {

        break;
      }

      for (final nextRoom in current.content.neighboringRooms) {
        if (!cameFrom.containsKey(nextRoom) && nextRoom.active) {
          frontier.enqueue(nextRoom);
          cameFrom[nextRoom] = current.content;
        }
      }
    }

    return cameFrom;

  }

  void updatePath() {

    print("updating path");
    Map<RoomArea, RoomArea?> pathBackwards = findPath();

    pathStack = DataStack.Stack<RoomArea>();

    RoomArea current = gameRef.player.currentRoomArea;
    pathStack.push(current);
    print(current.roomNumber);
    while (pathBackwards[current] != null) {
      current = pathBackwards[current]!;
      if (current != currentRoomArea) {
        print(current.roomNumber);
        pathStack.push(current);
      }
    }

  }

  void followPlayer(double dt) {

    Vector2 movementVector;

    if (gameRef.player.currentRoomArea == currentRoomArea) {

      Player player = gameRef.player;

      movementVector = Vector2(
          player.x - x,
          player.y - y
      );

      position += movementVector.normalized() * movementSpeed * dt;

    } else {

      if (pathStack.front() == null) {
        print("reconfiguring path");
        updatePath();
      }

      Vector2 nextRoomPosition = pathStack.front()!.content.roomPoint;

      movementVector = Vector2(
          nextRoomPosition.x - x,
          nextRoomPosition.y - y
      );

      position += movementVector.normalized() * movementSpeed * dt;

      print(pathStack.front()!.content.roomPoint.distanceTo(position));
      if (pathStack.front()!.content.roomPoint.distanceTo(position) < 40) {
        print("popping");
        pathStack.pop();
      }

    }

  }

  @override
  Future<void> setupAnimations() async {

    animation = SpriteAnimation.spriteList([
      await Sprite.load("ZombieRun1.png"),
      await Sprite.load("ZombieRun2.png"),
      await Sprite.load("ZombieRun3.png"),
      await Sprite.load("ZombieRun4.png")
    ], stepTime: 0.2);

  }

}
