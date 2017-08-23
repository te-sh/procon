T kitamasa(T, U)(T[] a, T[] x, U k)
{
  import std.range;

  auto n = a.length;
  auto t = new T[](n * 2 + 1);

  T[] rec(U k)
  {
    auto c = new T[](n);
    if (k < n) {
      c[k] = T(1);
    } else {
      auto b = rec(k / 2);
      t[] = T(0);
      foreach (i; 0..n)
        foreach (j; 0..n)
          t[i+j+(k&1)] += b[i] * b[j];
      foreach_reverse (i; n..n*2)
        foreach (j; 0..n)
          t[i-n+j] += a[j] * t[i];
      c[] = t[0..n][];
    }
    return c;
  }

  auto c = rec(k);

  T r;
  foreach (ci, xi; lockstep(c, x)) r += ci * xi;

  return r;
}

unittest
{
  import std.stdio;
  auto ai = [1, 2, 3];
  auto xi = [6, 5, 4];
  auto r = kitamasa(ai, xi, 10);
  assert(r == 220696);
}
