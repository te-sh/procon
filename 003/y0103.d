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

int[] primes(int n)
{
  auto sieve = new bool[]((n + 1) / 2);
  sieve[] = true;

  foreach (p; iota(1, (n.to!real.sqrt.to!int - 1) / 2 + 1))
    if (sieve[p])
      foreach (q; iota(p * 3 + 1, (n + 1) / 2, p * 2 + 1))
        sieve[q] = false;

  auto r = sieve.enumerate
    .filter!("a[1]")
    .map!("a[0]").map!("a * 2 + 1")
    .map!(to!int).array;
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
