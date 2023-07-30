class IdGenerator {
  int currId;
  int get nextId => currId++;
  IdGenerator({this. currId = 0});
  static const invalid_id = -1;
}
