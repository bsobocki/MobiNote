class IdGenerator {
  int currId = 0;
  int get nextId => currId++;
  IdGenerator();
}
