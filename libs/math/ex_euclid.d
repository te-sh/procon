pure T exEuclid(T)(T a, T b, ref T x, ref T y)
{
  auto g = a;
  x = 1;
  y = 0;
  if (b) {
    g = exEuclid(b, a%b, y, x);
    y -= a/b*x;
  }
  return g;
}

unittest
{
  int x, y, g;

  g = exEuclid(29, 17, x, y);
  assert(g == 1);
  assert(x == -7);
  assert(y == 12);

  g = exEuclid(12, 42, x, y);
  assert(g == 6);
  assert(x == -3);
  assert(y == 1);
}
