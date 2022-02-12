import 'package:cod_zombies_2d/entities/collidables.dart';
import 'package:cod_zombies_2d/entities/player.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class GameMap extends Component {

  final String mapName;

  late final Player player;

  late final TiledComponent map;

  late final int mapWidth;
  late final int mapHeight;
  late final int tileWidth;
  late final int tileHeight;
  late final int pixelWidth;
  late final int pixelHeight;

  GameMap(this.mapName) : super();

  @override
  Future<void>? onLoad() async {

    await this._loadMap();
    this._setupMap();

    return super.onLoad();

  }

  void _setupSpawnpoints() {

    final spawnPointsLayer = this.map.tileMap.getObjectGroupFromLayer("Spawnpoints");

    for (final spawnPoint in spawnPointsLayer.objects) {
      switch (spawnPoint.type) {
        case "Player":
          this.player = new Player(spawnPoint.x, spawnPoint.y, spawnPoint.width / Player.spriteHeight * 1.5);
          this.add(this.player);
      }
    }

  }

  void _setupCollidables() {

    final collidablesLayer = this.map.tileMap.getObjectGroupFromLayer("Walls");

    for (final collidable in collidablesLayer.objects) {
      final collidableWall = CollidableObject(
        Vector2(collidable.x, collidable.y),
        Vector2(collidable.width, collidable.height)
      );
      add(collidableWall);
    }

  }

  void _setupMap() {

    this._setupCollidables();
    this._setupSpawnpoints();

  }

  Future<void> _loadMap() async {

    this.map = await TiledComponent.load(this.mapName, Vector2.all(16));
    add(this.map);

    final actualTileMap = map.tileMap.map;

    this.mapWidth = actualTileMap.width;
    this.mapHeight = actualTileMap.height;
    this.tileWidth = actualTileMap.tileWidth;
    this.tileHeight = actualTileMap.tileHeight;

    this.pixelWidth = this.mapWidth * this.tileWidth;
    this.pixelHeight = this.mapHeight * this.tileHeight;

  }

}