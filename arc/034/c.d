import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];

  auto p = primes(a.nsqrt);
  int[int] f;

  foreach (i; b+1..a+1) {
    auto j = i;
    while (j > 1) {
      auto fi = factor(j, p);
      ++f[fi];
      j /= fi;
    }
  }

  auto ans = 1L;
  foreach (i; f.byValue)
    (ans *= i+1) %= mod;

  writeln(ans);
}

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
