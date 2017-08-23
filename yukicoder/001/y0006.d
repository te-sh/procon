import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!int;
  auto n = readln.chomp.to!int;

  auto pi = primes(n).assumeSorted!"a <= b".upperBound(k).array;
  auto hi = pi.map!hash.array;

  auto maxL = 1, maxP = pi[0], i = 0, j = 0;
  auto buf = new bool[](10);
  buf[hi[0]] = true;

  while (true) {
    if (++j >= pi.length) break;

    if (buf[hi[j]]) {
      foreach (ref h; hi[i..j].until(hi[j], OpenRight.no)) {
        buf[h] = false;
        ++i;
      }
    }

    auto len = j - i + 1;
    if (len >= maxL) {
      maxL = len;
      maxP = pi[i];
    }

    buf[hi[j]] = true;
  }

  writeln(maxP);
}

int hash(int n)
{
  static int[int] memo;

  if (n in memo) {
    return memo[n];
  } else if (n < 10) {
    return memo[n] = n;
  } else {
    auto r = 0;
    for (; n > 0; n /= 10)
      r += n % 10;
    return memo[n] = hash(r);
  }
}

pure int[] primes(int n)
{
  import std.math, std.bitmanip;

  auto sieve = BitArray();
  sieve.length((n + 1) / 2);
  sieve = ~sieve;

  foreach (p; 1..((n.to!real.sqrt.to!int - 1) / 2 + 1))
    if (sieve[p])
      for (auto q = p * 3 + 1; q < (n + 1) / 2; q += p * 2 + 1)
        sieve[q] = false;

  auto r = sieve.bitsSet.map!(to!int).map!("a * 2 + 1").array;
  r[0] = 2;

  return r;
}
