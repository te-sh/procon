import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), l = rd[0], h = rd[1];
  auto p = primes(h.nsqrt).to!(long[]);

  auto a = p.map!"a * a".assumeSorted!"a <= b".lowerBound(h).back;

  if (a >= l) {
    auto r = a, ra = a.nsqrt;
    for (auto b = ra+1; b*ra <= h; ++b)
      if (factor(b, p) > ra) r = b*ra;
    writeln(r);
  } else {
    auto b = new long[](h-l+1);
    foreach_reverse (pi; p)
      for (auto k = (l + pi - 1) / pi * pi; k <= h; k += pi)
        b[k-l] = pi;
    writeln(b.length - b.retro.maxIndex - 1 + l);
  }
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
