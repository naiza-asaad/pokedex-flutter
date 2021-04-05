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
