import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.ascii;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto s1 = readln.chomp;
  auto s2 = readln.chomp;

  auto m = 26, a = 'A';
  auto used = new bool[](m);
  auto decided = new bool[](m);
  auto top = new bool[](m);
  auto uf = UnionFind!int(m);

  if (!s1[0].isDigit) top[s1[0]-a] = true;
  if (!s2[0].isDigit) top[s2[0]-a] = true;

  foreach (c1, c2; lockstep(s1, s2)) {
    if (!c1.isDigit) used[c1-a] = true;
    if (!c2.isDigit) used[c2-a] = true;

    if (c1.isDigit) {
      if (c2.isDigit) {
        // noop
      } else {
        decided[c2-a] = true;
      }
    } else {
      if (c2.isDigit) {
        decided[c1-a] = true;
      } else {
        uf.unite(c1-a, c2-a);
      }
    }
  }

  auto r = 0, t = false;
  foreach (g; uf.groups) {
    if (!used[g[0]] || g.any!(gi => decided[gi])) continue;
    t |= g.any!(gi => top[gi]);
    ++r;
  }

  writeln(t ? 9 * 10L^^(r-1) : 10L^^r);
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
