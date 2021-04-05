class Type {
  String name;
  String url;

  Type({
    this.name,
    this.url,
  });

  factory Type.fromJson(Map<String, dynamic> parsedJson) {
    return Type(
      name: parsedJson['name'],
      url: parsedJson['url'],
    );
  }

  @override
  String toString() {
    return 'type name=$name\n';
  }
}
