import matrix, repeated_square;

auto fibonacchi(T, U)(U n)
{
  auto a = new T[][](2, 2);
  a = [[T(1), T(1)], [T(1), T(0)]];

  auto i = new T[][](2, 2);
  i = [[T(1), T(0)], [T(0), T(1)]];

  auto b = new T[][](2, 1);
  b = [[T(1)], [T(1)]];

  auto c = repeatedSquare!(T[][], matMul, U)(a, n - 1, i);
  return matMul(c, b)[1][0];
}

unittest
{
  assert(fibonacchi!(int, int)(15) == 610);
  assert(fibonacchi!(int, int)(20) == 6765);

  import factor_ring;
  alias FactorRing!100 mint;
  assert(fibonacchi!(mint, int)(15) == 10);
  assert(fibonacchi!(mint, int)(20) == 65);
}
