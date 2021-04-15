class Room {
  final String id;
  final String name;
  final String game;
  final String owner;

  Room(this.id,this.name,this.game,this.owner);

  factory Room.fromJson(json)
  {
    return Room(
        (json[0]??'') as String,
        (json[1]['name']??'') as String,
        (json[1]['game']??'') as String,
        (json[1]['owner']??'') as String
    );
  }
}