import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  auto pi = primes(n.to!real.sqrt.to!int);
  writeln(calc(n, pi) ? "YES" : "NO");
}

auto calc(long n, int[] pi)
{
  auto p1 = divP(n, pi);
  if (p1 == -1) return false;
  n /= p1;
  auto p2 = divP(n, pi);
  return p2 != -1;
}

auto divP(long n, int[] pi)
{
  foreach (p; pi) {
    if (p >= n) break;
    if (n % p == 0) return p;
  }
  return -1;
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
