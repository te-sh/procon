import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto c = readln.split.to!(real[]);

  auto a = new real[][](n-1, n);

  foreach (i; 0..n-1) {
    foreach (j; 0..n)
      a[i][j] = 0;
  }

  foreach (i; 0..n-1) {
    a[i][i] = -1;
    foreach (j; 1..m+1) {
      auto k = i+j;
      if (k == n-1) continue;
      if (k > n-1) k = n-1-(k-(n-1));
      a[i][k] += 1.0L/m;
      a[i][n-1] -= c[k-1]/m;
    }
  }

  gaussElimination(a, n-1);

  auto e = new real[](n-1);
  foreach (i; 0..n-1) e[i] = a[i][n-1];

  auto f = new real[](n-1);
  foreach_reverse (i; 0..n-1) {
    if (i+m >= n-1) {
      f[i] = 0;
    } else {
      auto r = 0.0L;
      foreach (j; 1..m+1)
        r += (f[i+j] + c[i+j-1]) / m;
      foreach (j; 1..m+1)
        r = min(r, e[i+j] + c[i+j-1]);
      f[i] = r;
    }
  }

  writefln("%.10f", f[0]);
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
