import 'package:cod_zombies_2d/datastructures/list_node.dart';

class Queue<T> {

  Node<T>? first;
  Node<T>? last;

  Queue();

  bool empty() {
    return first == null;
  }

  void enqueue(T content) {
    Node<T> newNode = Node<T>(content);
    if (empty()) {
      first = newNode;
      last = newNode;
    } else {
      last!.next = newNode;
      last = last!.next;
    }
  }

  Node<T>? dequeue() {

    if (empty()) return null;

    Node<T> value = first!;

    first = first!.next;

    if (first == null) {
      last = null;
    }

    return value;
  }

}