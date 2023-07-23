class IdGenerator {
  int currId;
  int get nextId => currId++;
  IdGenerator({this. currId = 0});
}
