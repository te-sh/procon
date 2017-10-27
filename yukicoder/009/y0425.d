import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), p = rd[0], q = rd[1];

  auto n = 101, a = new real[][](n, n+1);
  auto r2 = real(1)/2, r3 = real(1)/3;

  foreach (i; 0..n) {
    a[i][] = 0;
    a[i][i] = 1;
    a[i][max(i-q, 0)] -= r2 * i / 100;
    a[i][min(i+q, 100)] -= r3 * (100 - i) / 100;
    a[i][n] = (r2 * i + r3 * (100 - i)) / 100;
  }

  gaussElimination(a, n);

  writefln("%.7f", (a[p][n] + 1) * r3);
}

auto gaussElimination(T)(ref T[][] a, size_t n)
{
  import std.math;

  size_t p;
  T pmax;

  foreach (k; 0..n-1) {
    p = k;
    pmax = a[k][k].abs;

    foreach (i; k+1..n)
      if (a[i][k].abs > pmax) {
        p = i;
        pmax = a[i][k].abs;
      }

    if (p != k) swap(a[k], a[p]);

    auto akk = a[k][k];
    foreach (i; k+1..n) {
      auto aik = a[i][k];
      foreach (j; k..n+1)
        a[i][j] -= aik * (a[k][j] / akk);
    }
  }

  a[n-1][n] /= a[n-1][n-1];
  foreach_reverse (i; 0..n-1) {
    auto ax = T(0);
    foreach (j; i+1..n)
      ax += a[i][j] * a[j][n];
    a[i][n] = (a[i][n] - ax) / a[i][i];
  }
}
