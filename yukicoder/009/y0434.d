import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!int;
  auto s = new int[][](t);
  foreach (i; 0..t)
    s[i] = readln.chomp.map!(c => cast(int)(c - '0')).array;

  auto m = s.map!(si => si.length.to!int).reduce!max;
  auto p = primes(m);

  auto f = new long[][](m+1, 10);
  foreach (i; 2..m+1) {
    auto fi = i.factor(p);
    ++f[i][fi.toSingle];

    auto j = i/fi;
    if (j > 1) f[i][] += f[j][];
  }

  foreach (si; s) {
    auto n = si.length.to!int;
    auto c = new long[](10);
    auto r = 0;
    foreach (int j, sij; si) {
      auto ct = 1;
      foreach (int i, ci; c)
        if (ci)
          ct = (ct * repeatedSquare(i, ci)).toSingle;

      r = (r + ct * sij).toSingle;

      c[] += f[n-j-1][];
      c[] -= f[j+1][];
    }
    writeln(r);
  }
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n)
{
  return repeatedSquare(a, n, T(1));
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a).toSingle;
    a = predFun(a, a).toSingle;
    n >>= 1;
  }

  return r;
}

auto toSingle(int n)
{
  while (n >= 10) n = n/10 + n%10;
  return n;
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
