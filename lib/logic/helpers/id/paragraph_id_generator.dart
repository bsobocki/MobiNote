class IdGenerator {
  int currId;
  int get nextId => currId++;
  IdGenerator({this. currId = 0});
  static const invalidId = -1;
}
