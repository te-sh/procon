import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto pi = primes(n.to!real.sqrt.to!int);
  int[int] factors;

  while (n > 1) {
    auto p = factor(n, pi);
    ++factors[p];
    n /= p;
  }

  int[] ai = factors.values;
  writeln(ai.reduce!"a ^ b" != 0 ? "Alice" : "Bob");
}

auto factor(int n, int[] pi)
{
  auto ma = n.to!real.sqrt.to!int;
  foreach (p; pi) {
    if (p > ma) return n;
    if (n % p == 0) return p;
  }
  return n;
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
