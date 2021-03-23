
class SimplePokemonList {
  int count;
  String next;
  String previous;
  List<SimplePokemon> simplePokemonList;

  SimplePokemonList({
    this.count,
    this.next,
    this.previous,
    this.simplePokemonList,
  });

  factory SimplePokemonList.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['results'] as List;
    List<SimplePokemon> simplePokemonList = list.map((e) => SimplePokemon.fromJson(e)).toList();

    return SimplePokemonList(
      count: parsedJson['count'],
      next: parsedJson['next'],
      previous: parsedJson['previous'],
      simplePokemonList: simplePokemonList,
    );
  }

  @override
  String toString() {
    return 'count=$count, next=$next, previous=$previous, list=$simplePokemonList';
  }
}

class SimplePokemon {
  String name;
  String detailsUrl;

  SimplePokemon({
    this.name,
    this.detailsUrl,
  });

  factory SimplePokemon.fromJson(Map<String, dynamic> parsedJson) {
    return SimplePokemon(
      name: parsedJson['name'],
      detailsUrl: parsedJson['url'],
    );
  }

  @override
  String toString() {
    return 'name=$name\nurl=$detailsUrl';
  }
}