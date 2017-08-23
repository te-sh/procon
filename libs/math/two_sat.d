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

unittest
{
  auto sat1 = TwoSAT(3);
  sat1.addClause(0, ~1);
  sat1.addClause(1, 2);
  sat1.addClause(~2, ~0);
  assert(sat1.solve());

  auto sat2 = TwoSAT(2);
  sat2.addClause(0, 1);
  sat2.addClause(0, ~1);
  sat2.addClause(~0, 1);
  sat2.addClause(~0, ~1);
  assert(!sat2.solve());
}
