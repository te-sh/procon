import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags

const inf = 10 ^^ 6;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];
  auto uf = UnionFind!size_t(n);

  foreach (_; 0..m) {
    auto rd2 = readln.split.to!(size_t[]), x = rd2[0]-1, y = rd2[1]-1;
    uf.unite(x, y);
  }

  auto si = new int[](n);
  foreach (i; 0..n) ++si[uf.find(i)];
  auto ti = si.filter!"a > 0".array.sort().group.array;

  auto dp = new int[](n+1), ma = 0;
  dp[1..$] = inf;

  foreach (t; ti) {
    auto u = t[0], v = t[1].to!int;
    auto dp2 = new int[](n+1);

    if (v <= 20) {
      foreach (k; 0..n+1) {
        dp2[k] = dp[k];
        foreach (j; 1..v+1) {
          if (k < u*j) break;
          dp2[k] = min(dp2[k], dp[k-u*j] + j);
        }
      }
    } else {
      foreach (k; 0..n.to!int+1)
        if (dp[k] < inf)
          dp[k] -= k/u;

      auto deqs = new DList!size_t[](u);

      foreach (k; 0..n.to!int+1) {
        auto deq = &deqs[k % u], mi = max(k - u*v, 0);
        while (!deq.empty && deq.front < mi) deq.removeFront();
        while (!deq.empty && dp[deq.back] >= dp[k]) deq.removeBack();
        deq.insertBack(k);
        dp2[k] = dp[deq.front] + k/u;
      }
    }
    dp = dp2;
  }

  foreach (r; dp[1..$]) writeln(r >= inf ? -1 : r-1);
}

struct UnionFind(T)
{
  import std.algorithm, std.range;

  T[] p; // parent
  const T s; // sentinel
  const T n;

  this(T n)
  {
    this.n = n;
    p = new T[](n);
    s = n + 1;
    p[] = s;
  }

  T find(T i)
  {
    if (p[i] == s) {
      return i;
    } else {
      p[i] = find(p[i]);
      return p[i];
    }
  }

  void unite(T i, T j)
  {
    auto pi = find(i), pj = find(j);
    if (pi != pj) p[pj] = pi;
  }

  bool isSame(T i, T j) { return find(i) == find(j); }

  auto groups()
  {
    auto g = new T[][](n);
    foreach (i; 0..n) g[find(i)] ~= i;
    return g.filter!(l => !l.empty);
  }
}
