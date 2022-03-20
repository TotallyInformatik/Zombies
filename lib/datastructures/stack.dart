import 'package:cod_zombies_2d/datastructures/list_node.dart';

class Stack<T> {

  Node<T>? first;

  Stack();

  bool empty() {
    return first == null;
  }

  void push(T value) {

    Node<T> newNode = Node<T>(value);
    newNode.next = first;
    first = newNode;

  }

  Node<T>? pop() {

    if (empty()) return null;

    Node<T> value = first!;
    first = first!.next;

    return value;

  }

  Node<T>? front() {
    return first;
  }

}