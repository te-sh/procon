import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

const p = 10 ^^ 9 + 7;
alias Graph!(int, size_t) graph;
alias FactorRing!(p, true) mint;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto w = readln.split.to!(int[]);

  auto g = new int[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), i = rd2[0]-1, j = rd2[1]-1;
    g[i][j] = w[i];
  }
  auto d = graph.floydWarshal(g);

  auto ft = factTable!mint(1000);
  auto st = starling2!mint(1000);

  auto r = mint(0);

  foreach (i; 0..n)
    foreach (j; 0..n)
      if (i == j || d[i][j] < graph.inf && d[i][j] >= w[j])
        r += ft[w[j]] * st[w[i]][w[j]];

  writeln(r);
}

pure T[] factTable(T)(size_t n)
{
  auto t = new T[](n + 1);
  t[0] = T(1);
  foreach (i; 1..n+1)
    t[i] = t[i-1] * i;
  return t;
}

pure T[][] starling2(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = 0;
    t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + j.to!T * t[i - 1][j];
  }
  return t;
}

template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  import std.algorithm, std.array, std.conv;

  const inf = _inf, sent = _sent;

  Wt[][] floydWarshal(Wt[][] g)
  {
    Wt[][] dist;
    Node[][] inter;
    floydWarshal(g, dist, inter);
    return dist;
  }

  void floydWarshal(Wt[][] g, out Wt[][] dist, out Node[][] inter)
  {
    auto n = g.length;
    dist = g.map!(i => i.dup).array;

    inter = new Node[][](n, n);
    foreach (i; 0..n) inter[i][] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (j; 0..n)
          if (dist[i][k] && dist[k][j] && (!dist[i][j] || dist[i][j] < min(dist[i][k], dist[k][j]))) {
            dist[i][j] = min(dist[i][k], dist[k][j]);
            inter[i][j] = k.to!Node;
          }
  }
}

struct FactorRing(int m, bool pos = false)
{
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!(m, pos) opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const
  {
    static if (pos) return _v % m;
    else return (_v % m + m) % m;
  }

  pure auto opBinary(string op: "+")(long rhs) const { return FactorRing!(m, pos)(v + rhs); }
  pure auto opBinary(string op: "-")(long rhs) const { return FactorRing!(m, pos)(v - rhs); }
  pure auto opBinary(string op: "*")(long rhs) const { return FactorRing!(m, pos)(v * rhs); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.v); }

  auto opOpAssign(string op: "+")(long rhs) { v = mod(v + rhs); }
  auto opOpAssign(string op: "-")(long rhs) { v = mod(v - rhs); }
  auto opOpAssign(string op: "*")(long rhs) { v = mod(v * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.v); }
}
