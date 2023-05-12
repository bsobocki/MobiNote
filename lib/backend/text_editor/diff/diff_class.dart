class Diff {}

class Add extends Diff {
  final String elem;

  Add({required this.elem});
}

class Remove extends Diff {
  final int index;

  Remove({required this.index});
}