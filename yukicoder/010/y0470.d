import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto u = new string[](n);
  foreach (i; 0..n) u[i] = readln.chomp;

  if (n > 52) {
    writeln("Impossible");
    return;
  }

  auto ts = TwoSAT(n);

  foreach (int i, ui; u) {
    auto sit = ui[0..1], tit = ui[1..3], sif = ui[0..2], tif = ui[2..3];
    foreach (int j, uj; u) {
      if (j <= i) continue;
      auto sjt = uj[0..1], tjt = uj[1..3], sjf = uj[0..2], tjf = uj[2..3];
      if (sit == sjt || tit == tjt) ts.addClause(~i, ~j);
      if (sit == tjf || tit == sjf) ts.addClause(~i, j);
      if (sif == tjt || tif == sjt) ts.addClause(i, ~j);
      if (sif == sjf || tif == tjf) ts.addClause(i, j);
    }
  }

  if (!ts.solve()) {
    writeln("Impossible");
    return;
  }

  auto idx = new int[](n*2);
  foreach (int i, oi; ts.ord) idx[oi+n] = i;

  foreach (int i, ui; u) {
    if (idx[~i+n] > idx[i+n]) writeln(ui[0..2], " ", ui[2..3]);
    else                      writeln(ui[0..1], " ", ui[1..3]);
  }
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
