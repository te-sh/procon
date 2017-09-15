import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  struct Road { size_t a, b; int y; }
  struct Query { size_t i, v; int w; size_t ans; }

  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto road = new Road[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!size_t; rd2.popFront();
    auto b = rd2.front.to!size_t; rd2.popFront();
    auto y = rd2.front.to!int;
    road[i] = Road(a, b, y);
  }

  auto q = readln.chomp.to!size_t;
  auto query = new Query[](q);
  foreach (i; 0..q) {
    auto rd3 = readln.splitter;
    auto v = rd3.front.to!size_t; rd3.popFront();
    auto w = rd3.front.to!int;
    query[i] = Query(i, v, w);
  }

  road.sort!"a.y > b.y";
  query.sort!"a.w > b.w";

  auto uf = UnionFind(n), qi = 0;

  foreach (r; road) {
    while (r.y <= query[qi].w && qi < q) {
      query[qi].ans = uf.countNodesOf(query[qi].v);
      ++qi;
    }
    uf.unite(r.a, r.b);
  }

  while (qi < q) {
    query[qi].ans = uf.countNodesOf(query[qi].v);
    qi++;
  }

  query.sort!"a.i < b.i";
  foreach (qu; query) writeln(qu.ans);
}

struct UnionFind
{
  import std.algorithm, std.range;

  size_t[] p; // parent
  const size_t s; // sentinel
  const size_t n;
  size_t countForests; // number of forests
  size_t[] countNodes; // number of nodes in forests

  this(size_t n)
  {
    this.n = n;
    s = n;
    p = new size_t[](n);
    p[] = s;
    countForests = n;
    countNodes = new size_t[](n);
    countNodes[] = 1;
  }

  size_t opIndex(size_t i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = this[p[i]];
      return p[i];
    }
  }

  bool unite(size_t i, size_t j)
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

  auto countNodesOf(size_t i) { return countNodes[this[i]]; }
  bool isSame(size_t i, size_t j) { return this[i] == this[j]; }

  auto groups()
  {
    auto g = new size_t[][](n);
    foreach (i; 0..n) g[this[i]] ~= i;
    return g.filter!(l => !l.empty);
  }
}
