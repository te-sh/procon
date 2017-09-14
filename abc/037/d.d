import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias mint = FactorRing!mod;
alias graph = Graph!size_t;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), h = rd1[0], w = rd1[1], n = h*w;
  auto a = new int[][](h, w);
  foreach (i; 0..h) {
    auto rd2 = readln.splitter;
    foreach (j; 0..w) {
      a[i][j] = rd2.front.to!int;
      rd2.popFront();
    }
  }

  auto g = new size_t[][](n), rg = new size_t[][](n);

  auto id(size_t i, size_t j) { return i*w+j; }
  auto addEdge(size_t i1, size_t j1, size_t i2, size_t j2)
  {
    auto id1 = id(i1, j1), id2 = id(i2, j2);
    g[id1] ~= id2;
    rg[id2] ~= id1;
  }

  foreach (i; 0..h)
    foreach (j; 0..w) {
      if (i > 0   && a[i][j] < a[i-1][j]) addEdge(i, j, i-1, j);
      if (i < h-1 && a[i][j] < a[i+1][j]) addEdge(i, j, i+1, j);
      if (j > 0   && a[i][j] < a[i][j-1]) addEdge(i, j, i, j-1);
      if (j < w-1 && a[i][j] < a[i][j+1]) addEdge(i, j, i, j+1);
    }

  auto s = graph.topologicalSort(g), p = new mint[](n), ans = mint(0);
  foreach (u; s)
    ans += p[u] = (rg[u].empty ? 0 : rg[u].map!(v => p[v]).sum) + 1;

  writeln(ans);
}

template Graph(Node)
{
  import std.container;

  Node[] topologicalSort(Node[][] g)
  {
    auto n = g.length, h = new size_t[](n);

    foreach (u; 0..n)
      foreach (v; g[u])
        ++h[v];

    auto st = SList!Node();
    foreach (i; 0..n)
      if (h[i] == 0) st.insertFront(i);

    Node[] ans;
    while (!st.empty()) {
      auto u = st.front; st.removeFront();
      ans ~= u;
      foreach (v; g[u]) {
        --h[v];
        if (h[v] == 0) st.insertFront(v);
      }
    }

    return ans;
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
}
