T repeatedSquare(T, alias pred = "a * b", U)(T a, U n)
{
  return repeatedSquare(a, n, T(1));
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}

unittest
{
  assert(repeatedSquare(2, 0) == 1);
  assert(repeatedSquare(2, 1) == 2);
  assert(repeatedSquare(2, 5) == 32);
}
