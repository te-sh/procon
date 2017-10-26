import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1], q = rd[2];
  auto e1 = loadEdges(m), e2 = loadEdges(q);

  auto uf = UnionFind!int(n);

  auto e2s = e2.dup.sort!("a.u == b.u ? a.v < b.v : a.u < b.u");
  foreach (ei; e1.filter!(ei => !e2s.contains(ei))) {
    uf.unite(ei.u, ei.v);
  }

  auto ans = new int[](n);
  ans[] = -1;

  foreach_reverse (i, ei; e2) {
    if (uf[ei.u] == uf[0] && uf[ei.v] != uf[0])
      foreach (v; uf.nodes[uf[ei.v]][]) ans[v] = i.to!int+1;
    if (uf[ei.v] == uf[0] && uf[ei.u] != uf[0])
      foreach (u; uf.nodes[uf[ei.u]][]) ans[u] = i.to!int+1;
    uf.unite(ei.u, ei.v);
  }

  foreach (i; 1..n)
    if (uf[i] != uf[0]) ans[i] = 0;

  foreach (i; 1..n) writeln(ans[i]);
}

struct Edge { int u, v; }

auto loadEdges(size_t m)
{
  auto e = new Edge[](m);
  foreach (i; 0..m) {
    auto rd = readln.splitter;
    auto a = rd.front.to!int-1; rd.popFront();
    auto b = rd.front.to!int-1;
    e[i] = Edge(a, b);
  }
  return e;
}

struct UnionFind(T)
{
  import std.algorithm, std.container, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;
  T countForests; // number of forests
  T[] countNodes; // number of nodes in forests
  DoubleLinkedList!T[] nodes;

  this(T n)
  {
    this.n = n;
    s = n;
    p = new T[](n);
    p[] = s;
    countForests = n;
    countNodes = new T[](n);
    countNodes[] = 1;
    nodes = new DoubleLinkedList!T[](n);
    foreach (i; 0..n) {
      nodes[i] = new DoubleLinkedList!T();
      nodes[i] ~= i;
    }
  }

  T opIndex(T i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = this[p[i]];
      return p[i];
    }
  }

  bool unite(T i, T j)
  {
    auto pi = this[i], pj = this[j];
    if (pi != pj) {
      p[pj] = pi;
      --countForests;
      countNodes[pi] += countNodes[pj];
      nodes[pi] ~= nodes[pj];
      return true;
    } else {
      return false;
    }
  }

  auto countNodesOf(T i) { return countNodes[this[i]]; }
  bool isSame(T i, T j) { return this[i] == this[j]; }

  auto groups()
  {
    auto g = new T[][](n);
    foreach (i; 0..n) g[this[i]] ~= i;
    return g.filter!(l => !l.empty);
  }
}

class DoubleLinkedList(T)
{
  class Node
  {
    Node prev, next;
    T value;

    this(T value) { this.value = value; }
  }

  struct Range
  {
    Node root;
    T front() { return root.next.value; }
    void popFront() { root = root.next; }
    bool empty() { return !root.next; }
  }

  Node root, last;

  this()
  {
    root = new Node(T.init);
    last = root;
  }

  auto opOpAssign(string op: "~")(T value)
  {
    auto node = new Node(value);
    last.next = node;
    node.prev = last;
    last = node;
  }

  auto opOpAssign(string op: "~")(DoubleLinkedList!T list)
  {
    last.next = list.root;
    list.root.prev = last;
    last = list.last;
  }

  auto opSlice() { return Range(root); }
}
