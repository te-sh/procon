T[][] matMul(T)(T[][] a, T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m)
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  return c;
}

T[] matMulVec(T)(T[][] a, T[] b)
{
  auto l = b.length, m = a.length;
  auto c = new T[](m);
  foreach (i; 0..m)
    foreach (j; 0..l)
      c[i] += a[i][j] * b[j];
  return c;
}

unittest
{
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
}
