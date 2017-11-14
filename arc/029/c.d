import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];

  struct Edge { int a, b, r; }
  auto g = new Edge[](n+m);

  foreach (i; 0..n) {
    auto c = readln.chomp.to!int;
    g[i] = Edge(0, i+1, c);
  }

  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int; rd2.popFront();
    auto b = rd2.front.to!int; rd2.popFront();
    auto r = rd2.front.to!int;
    g[n+i] = Edge(a, b, r);
  }

  g.sort!"a.r < b.r";

  auto uf = UnionFind!int(n+1), ans = 0L;
  foreach (e; g) {
    if (uf[e.a] != uf[e.b]) {
      uf.unite(e.a, e.b);
      ans += e.r;
    }
  }

  writeln(ans);
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
