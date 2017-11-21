import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], q = rd[1];

  auto uf = UnionFind!int(n), eo = new bool[](n);
  foreach (_; 0..q) {
    auto rd2 = readln.splitter;
    auto w = rd2.front.to!int; rd2.popFront();
    auto x = rd2.front.to!int-1; rd2.popFront();
    auto y = rd2.front.to!int-1; rd2.popFront();
    auto z = rd2.front.to!int%2 == 0;

    auto px = uf[x], py = uf[y];
    if (w == 1) {
      if (px == py) {
        if (z && eo[x] != eo[y] || !z && eo[x] == eo[y])
          uf.superForest[px] = true;
      } else {
        if (z && eo[x] != eo[y] || !z && eo[x] == eo[y]) {
          foreach (i; uf.countNodes[px] > uf.countNodes[py] ? uf.nodes[py] : uf.nodes[px])
            eo[i] = !eo[i];
        }
        uf.unite(x, y);
      }
    } else {
      writeln(px == py && (eo[x] == eo[y] || uf.superForest[px]) ? "YES" : "NO");
    }
  }
}

struct UnionFind(T)
{
  import std.algorithm, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;
  T countForests; // number of forests
  T[] countNodes; // number of nodes in forests

  T[][] nodes;
  bool[] superForest;

  this(T n)
  {
    this.n = n;
    s = n;
    p = new T[](n);
    p[] = s;
    countForests = n;
    countNodes = new T[](n);
    countNodes[] = 1;

    nodes = new T[][](n);
    foreach (i; 0..n) nodes[i] = [i];
    superForest = new bool[](n);
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

      if (countNodes[pi] > countNodes[pj]) {
        nodes[pi] ~= nodes[pj];
      } else {
        nodes[pj] ~= nodes[pi];
        nodes[pi] = nodes[pj];
      }
      nodes[pj] = [];

      superForest[pi] |= superForest[pj];

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
