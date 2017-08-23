import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  calc2();
}

auto calc1()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto g = new bool[][](n, m);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(size_t[]), l = rd2[0], r = rd2[1] + 1;
    foreach (j; l..r) g[i][j] = true;
  }

  auto ci = new int[](m);
  foreach (i; 0..m)
    ci[i] = g.transversal(i).count!"a".to!int;

  if (m % 2 && ci[m/2+1] >= 2) {
    writeln("NO");
    return;
  }

  foreach (i; 0..m/2)
    if (ci[i] + ci[$-i-1] >= 3) {
      writeln("NO");
      return;
    }

  writeln("YES");
}

auto calc2()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];

  struct LR
  {
    int l, r;

    auto isOverlap(LR rhs) { return l <= rhs.r && rhs.l <= r; }
    auto reversed() { return LR(m - r - 1, m - l - 1); }
  }

  auto lri = n.iota.map!(_ => readln.split.to!(int[])).map!(rd2 => LR(rd2[0], rd2[1])).array;

  auto sat = TwoSAT(n);

  foreach (i; 0..n-1)
    foreach (j; i+1..n) {
      if (lri[i].isOverlap(lri[j]) && lri[i].isOverlap(lri[j].reversed)) {
        writeln("NO");
        return;
      }

      if (lri[i].isOverlap(lri[j])) {
        sat.addClause(i, j);
        sat.addClause(~i, ~j);
      } else if (lri[i].isOverlap(lri[j].reversed)) {
        sat.addClause(i, ~j);
        sat.addClause(~i, j);
      }
    }

  writeln(sat.solve() ? "YES" : "NO");
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
