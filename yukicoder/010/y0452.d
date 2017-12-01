import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];

  auto c = new int[][][](m, n, n);
  foreach (i; 0..m)
    foreach (j; 0..n)
      c[i][j] = readln.split.to!(int[]);

  auto l = new int[][][](m, n*2+2, n);
  foreach (i; 0..m) {
    foreach (j; 0..n)
      foreach (k; 0..n) l[i][j][k] = c[i][j][k];
    foreach (j; 0..n)
      foreach (k; 0..n) l[i][j+n][k] = c[i][k][j];
    foreach (k; 0..n) l[i][n*2][k] = c[i][k][k];
    foreach (k; 0..n) l[i][n*2+1][k] = c[i][k][n-1-k];

    foreach (j; 0..n*2+2) l[i][j].sort();
  }

  auto ans = n*n;
  foreach (i; 0..m)
    foreach (j; 0..n*2+2) {
      auto r = n*n;
      foreach (i2; 0..m) {
        if (i == i2) continue;
        foreach (j2; 0..n*2+2) {
          auto s = setIntersection(l[i][j], l[i2][j2]);
          ans = min(ans, n*2-s.walkLength-1);
        }
      }
    }

  writeln(ans);
}
