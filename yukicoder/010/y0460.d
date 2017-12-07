import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), m = rd[0], n = rd[1];
  auto a = new bool[][](m, n);
  foreach (i; 0..m)
    a[i] = readln.split.map!(aij => aij == "1").array;

  auto inf = 10^^3;

  auto w(bool[][] a)
  {
    foreach (i; 0..m) {
      foreach (j; 0..n)
        write(a[i][j] ? "1" : "0");
      writeln;
    }
  }

  auto reverse(ref bool[][] a, int i, int j)
  {
    foreach (i2; max(0, i-1)..min(m, i+2))
      foreach (j2; max(0, j-1)..min(n, j+2))
        a[i2][j2] = !a[i2][j2];
  }

  auto calc(bool[][] a, ref bool[][] b)
  {
    auto c = a.map!(ai => ai.dup).array;

    foreach (i; 0..m)
      if (b[i][0]) reverse(c, i, 0);
    foreach (j; 1..n)
      if (b[0][j]) reverse(c, 0, j);

    foreach (i; 1..m)
      foreach (j; 1..n) {
        b[i][j] = c[i-1][j-1];
        if (b[i][j]) reverse(c, i, j);
      }

    foreach (i; 0..m)
      if (c[i][n-1]) return inf;
    foreach (j; 0..n-1)
      if (c[m-1][j]) return inf;

    return b.map!(bi => bi.count(true)).sum.to!int;
  }

  auto ans = inf;

  foreach (i; 0..1<<(m+n-1)) {
    auto b = new bool[][](m, n);
    foreach (j; 0..m)
      b[j][0] = i.bitTest(j);
    foreach (j; 1..n)
      b[0][j] = i.bitTest(j+m-1);
    ans = min(ans, calc(a, b));
  }

  if (ans == inf) writeln("Impossible");
  else            writeln(ans);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }
}
