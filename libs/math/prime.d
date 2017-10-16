pure T[] primes(T)(T n)
{
  import std.algorithm, std.bitmanip, std.conv, std.range;

  auto sieve = BitArray();
  sieve.length((n + 1) / 2);
  sieve = ~sieve;

  foreach (p; 1..((nsqrt(n) - 1) / 2 + 1))
    if (sieve[p])
      for (auto q = p * 3 + 1; q < (n + 1) / 2; q += p * 2 + 1)
        sieve[q] = false;

  auto r = sieve.bitsSet.map!(to!T).map!("a * 2 + 1").array;
  r[0] = 2;

  return r;
}

pure T factor(T)(T n, const T[] p)
{
  auto ma = nsqrt(n) + 1;
  foreach (pi; p)
    if (pi > ma) return n;
    else if (n % pi == 0) return pi;
  return n;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}

unittest
{
  assert(primes(2) == [2]);
  assert(primes(3) == [2, 3]);
  assert(primes(4) == [2, 3]);
  assert(primes(5) == [2, 3, 5]);
  assert(primes(30) == [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]);
}

unittest
{
  auto pi = primes(100);
  assert(factor(10, pi) == 2);
  assert(factor(11, pi) == 11);
  assert(factor(15, pi) == 3);
  assert(factor(35, pi) == 5);
}
