class ParagraphIdGenerator {
  int currId = 0;
  int get nextId => currId++;
}

ParagraphIdGenerator paragraphIdGenerator = ParagraphIdGenerator();
