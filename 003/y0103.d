import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto mi = readln.split.to!(int[]);

  auto maxM = mi.fold!max;
  auto pi = primes(maxM.to!real.sqrt.to!int + 1);

  auto r = mi.map!(m => factors(m, pi)).joiner.map!"a % 3".fold!"a ^ b";
  writeln(r ? "Alice" : "Bob");
}

int[] factors(int n, int[] pi)
{
  int[int] buf;
  while (n > 1) {
    auto f = factor(n, pi);
    ++buf[f];
    n /= f;
  }
  return buf.values;
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

int factor(int i, int[] pi)
{
  auto ma = i.to!real.sqrt.to!int + 1;
  foreach (p; pi)
    if (p > ma) return i;
    else if (i % p == 0) return p;
  return i;
}
