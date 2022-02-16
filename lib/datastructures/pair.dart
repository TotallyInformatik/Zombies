class Pair<T, G> {

  T e1;
  G e2;

  Pair(this.e1, this.e2);

  @override
  bool operator ==(Object other) {
    return (other is Pair && other.e1 == e1 && other.e2 == e2);
  }

  @override
  int get hashCode => Object.hash(e1, e2);


}