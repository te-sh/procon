import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = 100;
  auto n = readln.chomp.to!int;

  struct Ligher { int r0, c0, r1, c1; }
  auto l = new Ligher[](n);
  auto g = new int[][][](m, m);

  foreach (i; 0..n) {
    auto rd = readln.split.to!(int[]), r0 = rd[0]-1, c0 = rd[1]-1, r1 = rd[2]-1, c1 = rd[3]-1;
    l[i] = Ligher(r0, c0, r1, c1);
    g[r0][c0] ~= i;
    g[r1][c1] ~= i;
  }

  auto ts = TwoSAT(n);
  foreach (i; 0..m)
    foreach (j; 0..m) {
      auto ng = g[i][j].length.to!int;
      foreach (gi; 0..ng-1)
        foreach (gj; gi+1..ng) {
          auto li = g[i][j][gi], lj = g[i][j][gj];
          ts.addClause(l[li].r0 == i && l[li].c0 == j ? ~li : li, l[lj].r0 == i && l[lj].c0 == j ? ~lj : lj);
        }
    }

  writeln(ts.solve() ? "YES" : "NO");
}

struct TwoSAT
{
  import std.algorithm;
  import std.stdio;

  int n;
  bool[] x;
  int[] num, col, ord;
  int[][] imp, rmp;

  this(int n)
  {
    this.n = n;
    auto n2 = n * 2;
    x = new bool[](n2);
    num = new int[](n2);
    col = new int[](n2);
    imp = new int[][](n2);
    rmp = new int[][](n2);
  }

  auto addClause(int u, int v)
  {
    if (u == ~v) {
      return;
    } else if (u == v) {
      x[u+n] = true;
    } else {
      imp[~u+n] ~= v;
      imp[~v+n] ~= u;
      rmp[u+n] ~= ~v;
      rmp[v+n] ~= ~u;
    }
  }

  auto solve() {
    foreach (u; -n..n)
      if (x[u+n]) visit(u, false);
    foreach (u; -n..n)
      if (x[u+n] && x[~u+n]) return false;
      else visit(u, 0);
    num = col.dup;
    ord.reverse();
    foreach (v; ord) rvisit(v, v);
    foreach (u; 0..n)
      if (col[u+n] == col[~u+n]) return false;
    return true;
  }

  private auto visit(int u, bool b)
  {
    if (num[u+n]++ > 0) return;
    x[u+n] |= b;
    foreach (v; imp[u+n]) visit(v, x[u+n]);
    ord ~= u;
  }

  private auto rvisit(int u, int k)
  {
    if (num[u+n]++ > 0) return;
    col[u+n] = k;
    foreach (v; rmp[u+n]) rvisit(v, k);
  }
}
