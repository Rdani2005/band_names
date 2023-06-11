import 'dart:convert';

class Band {
  String id;
  String name;
  int votes;

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  factory Band.fromMap(Map<String, dynamic> map) => Band(
        id: map['id'] ?? 'no-id',
        name: map['name'] ?? 'no-name',
        votes: map['votes'] ?? 0,
      );

  factory Band.fromJson(String str) => Band.fromMap(json.decode(str));
}
