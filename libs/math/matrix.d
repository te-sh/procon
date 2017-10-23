T[][] matMul(T)(const T[][] a, const T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m) {
    static if (T.init != 0) c[i][] = 0;
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  }
  return c;
}

T[] matMulVec(T)(const T[][] a, const T[] b)
{
  auto l = b.length, m = a.length;
  auto c = new T[](m);
  static if (T.init != 0) c[] = 0;
  foreach (i; 0..m)
    foreach (j; 0..l)
      c[i] += a[i][j] * b[j];
  return c;
}

T matDet(T)(const T[][] a)
{
  import std.algorithm, std.math;

  auto n = a.length, b = new T[][](n), d = T(1);
  foreach (i; 0..n) b[i] = a[i].dup;

  foreach (i; 0..n) {
    auto p = i;
    foreach (j; i+1..n)
      if (b[p][i].abs < b[j][i].abs) p = j;
    swap(b[p], b[i]);
    foreach (j; i+1..n)
      foreach (k; i+1..n)
        b[j][k] -= b[i][k] * b[j][i] / b[i][i];
    d *= b[i][i];
    if (p != i) d = -d;
  }

  return d;
}

unittest
{
  import std.math;

  auto a = new int[][](2, 2);
  a = [[5, 2], [3, 1]];

  auto b = new int[][](2, 1);
  b = [[1], [2]];

  auto c = matMul(a, b);

  assert(c[0][0] == 9);
  assert(c[1][0] == 5);

  auto d = new int[](2);
  d = [1, 2];

  auto e = matMulVec(a, d);

  assert(e[0] == 9);
  assert(e[1] == 5);

  auto f = new real[][](3, 3);
  f = [[3, 4, -1], [2, 5, -2], [1, 6, -4]];
  auto g = matDet(f);
  assert((g + 7).abs < 1e-7L);
}
