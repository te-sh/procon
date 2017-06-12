import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto x = readln.chomp.to!long;
  auto pi = primes(10L ^^ 6);

  long[long] fi;
  while (x > 1) {
    auto f = factor(x, pi);
    ++fi[f];
    x /= f;
  }

  auto r = 1L;
  foreach (f, c; fi)
    if (c % 2) r *= f;

  writeln(r);
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

pure T factor(T)(T n, const T[] pi)
{
  auto ma = nsqrt(n) + 1;
  foreach (p; pi)
    if (p > ma) return n;
    else if (n % p == 0) return p;
  return n;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}
