import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], t = rd1[1], mod = rd1[2];

  if (mod == 1) {
    writeln(0);
    return;
  }

  auto b = new int[](t+2);
  auto setImos(int k, int p) { b[1] += p; b[k+1] -= p; }

  foreach (_; 0..n) {
    auto rd2 = readln.splitter;
    auto x = rd2.front.to!int.abs; rd2.popFront();
    auto y = rd2.front.to!int.abs;

    if (x+y > t || (t-(x+y)) % 2) {
      writeln(0);
      return;
    }

    auto w = (t-(x+y))/2;

    setImos(t, 2);
    setImos(w, -1);
    setImos(w+x, -1);
    setImos(w+y, -1);
    setImos(w+x+y, -1);
  }

  foreach (i; 1..t+2) b[i] += b[i-1];

  auto p = primes(t), ans = 1L;
  foreach_reverse (i; 2..t+1)
    if (b[i]) {
      auto f = factor(i, p);
      if (f == i) {
        (ans *= repeatedSquare(cast(long)(i), b[i], mod)) %= mod;
      } else {
        b[f] += b[i];
        b[i/f] += b[i];
      }
    }

  writeln(ans);
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T mod)
{
  return repeatedSquare(a, n, T(1), mod);
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init, T mod)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a) % mod;
    a = predFun(a, a) % mod;
    n >>= 1;
  }

  return r;
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
