class IdGenerator {
  int currId = 0;
  int get nextId => currId++;
  final String type;

  static final Map<String, IdGenerator> instances = {};

  factory IdGenerator(String type) {
    if (!instances.keys.contains(type)) {
      instances[type] = IdGenerator._internal(type: type);
    }
    return instances[type]!;
  }

  IdGenerator._internal({required this.type});
}

IdGenerator paragraphIdGenerator = IdGenerator('paragraph');
IdGenerator widgetIdGenerator = IdGenerator('widget');
