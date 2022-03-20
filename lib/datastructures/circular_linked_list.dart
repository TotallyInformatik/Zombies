import 'package:cod_zombies_2d/datastructures/list_node.dart';

class CircularLinkedList<T extends Node> {

  /// TODO: finish implementation

  late T first;
  late T last;

  CircularLinkedList(node) {
    first = node;
    last = node;
  }

  addNode(T node) {

    last.next = node;
    last = node;
    last.next = first;

  }

}