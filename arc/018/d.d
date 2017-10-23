import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias mint = FactorRing!mod;

struct EdgeC { int a, b, c; }
struct Edge { int a, b; }

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];

  auto e = new EdgeC[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!int;
    e[i] = EdgeC(a, b, c);
  }
  e.sort!"a.c < b.c";

  auto uf = UnionFind!int(n), ansCost = 0L, ansCombi = mint(1);

  while (!e.empty) {
    auto d = pickEdgesSameCost(e);

    auto g = new Edge[](d.length);
    foreach (i, di; d) g[i] = Edge(uf[di.a], uf[di.b]);
    auto ng = compressNode(g);

    auto uf2 = UnionFind!int(ng);
    foreach (gi; g) uf2.unite(gi.a, gi.b);

    foreach (group; uf2.groups) {
      auto h = pickEdgesSameGroup(g, ng, group);
      auto nh = compressNode(h);
      ansCombi *= spannings(h, nh);
      ansCost += (nh-1) * d[0].c;
    }

    foreach (di; d) uf.unite(di.a, di.b);
  }

  writeln(ansCost, " ", ansCombi);
}

auto pickEdgesSameCost(ref EdgeC[] e)
{
  auto i = e.countUntil!(ei => ei.c != e[0].c);
  if (i == -1) i = e.length;
  auto d = e[0..i]; e = e[i..$];
  return d;
}

auto pickEdgesSameGroup(ref Edge[] g, int ng, int[] group)
{
  auto b = new bool[](ng);
  foreach (i; group) b[i] = true;
  return g.filter!(gi => b[gi.a] || b[gi.b]).array;
}

auto compressNode(ref Edge[] g)
{
  int[] nodes;
  foreach (gi; g) nodes ~= [gi.a, gi.b];
  nodes = nodes.sort().array.uniq.array;

  int[int] buf;
  foreach (int i, node; nodes) buf[node] = i;

  foreach (ref gi; g) {
    gi.a = buf[gi.a];
    gi.b = buf[gi.b];
  }

  return nodes.length.to!int;
}

auto spannings(Edge[] h, int nh)
{
  auto m = new mint[][](nh, nh);
  foreach (hi; h) {
    if (hi.a != hi.b) {
      m[hi.a][hi.b] -= 1;
      m[hi.b][hi.a] -= 1;
    }
  }
  foreach (i; 0..nh) m[i][i] = -m[i].sum;

  auto y = new mint[][](nh-1, nh-1);
  foreach (i; 0..nh-1)
    y[i] = m[i+1][1..$];

  return matDet(y);
}

T matDet(T)(const T[][] a)
{
  import std.algorithm, std.math;

  auto n = a.length, b = new T[][](n), d = T(1);
  foreach (i; 0..n) b[i] = a[i].dup;

  foreach (i; 0..n) {
    auto p = i;
    foreach (j; i+1..n)
      if (b[p][i] < b[j][i]) p = j;
    swap(b[p], b[i]);
    foreach (j; i+1..n)
      foreach (k; i+1..n)
        b[j][k] -= b[i][k] * b[j][i] / b[i][i];
    d *= b[i][i];
    if (p != i) d = -d;
  }

  return d;
}

struct UnionFind(T)
{
  import std.algorithm, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;
  T countForests; // number of forests
  T[] countNodes; // number of nodes in forests

  this(T n)
  {
    this.n = n;
    s = n;
    p = new T[](n);
    p[] = s;
    countForests = n;
    countNodes = new T[](n);
    countNodes[] = 1;
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

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

  @property int toInt() { return vi; }
  alias toInt this;

  this(int v) { vi = v; }
  this(int v, bool runMod) { vi = runMod ? mod(v) : v; }
  this(long v) { vi = mod(v); }

  ref FactorRing!(m, pos) opAssign(int v) { vi = v; return this; }

  pure auto mod(int v) const
  {
    static if (pos) return v % m;
    else return (v % m + m) % m;
  }

  pure auto mod(long v) const
  {
    static if (pos) return cast(int)(v % m);
    else return cast(int)((v % m + m) % m);
  }

  static if (!pos) {
    pure auto opUnary(string op: "-")() const { return FactorRing!(m, pos)(mod(-vi)); }
  }

  static if (m < int.max / 2) {
    pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!(m, pos)(mod(vi + rhs)); }
    pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!(m, pos)(mod(vi - rhs)); }
  } else {
    pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!(m, pos)(mod(vl + rhs)); }
    pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!(m, pos)(mod(vl - rhs)); }
  }
  pure auto opBinary(string op: "*")(int rhs) const { return FactorRing!(m, pos)(mod(vl * rhs)); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
  if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.vi); }

  static if (m < int.max / 2) {
    auto opOpAssign(string op: "+")(int rhs) { vi = mod(vi + rhs); }
    auto opOpAssign(string op: "-")(int rhs) { vi = mod(vi - rhs); }
  } else {
    auto opOpAssign(string op: "+")(int rhs) { vi = mod(vl + rhs); }
    auto opOpAssign(string op: "-")(int rhs) { vi = mod(vl - rhs); }
  }
  auto opOpAssign(string op: "*")(int rhs) { vi = mod(vl * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.vi); }

  pure auto opBinary(string op: "/")(FactorRing!(m, pos) rhs) { return FactorRing!(m, pos)(mod(vl * rhs.inv.vi)); }
  pure auto opBinary(string op: "/")(int rhs) { return opBinary!op(FactorRing!(m, pos)(rhs)); }
  auto opOpAssign(string op: "/")(FactorRing!(m, pos) rhs) { vi = mod(vl * rhs.inv.vi); }
  auto opOpAssign(string op: "/")(int rhs) { return opOpAssign!op(FactorRing!(m, pos)(rhs)); }

  pure auto inv() const
  {
    int x = vi, a, b;
    exEuclid(x, m, a, b);
    return FactorRing!(m, pos)(mod(a));
  }
}

pure T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b != 0) {
    g = exEuclid(b, a % b, y, x);
    y -= a / b * x;
  }
  return g;
}
