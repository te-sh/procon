import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto pi = primes(n);
  auto gi = new int[](n + 1);
  auto ai = new bool[](n);

  foreach (int i; iota(4, n + 1)) {
    ai[] = false;
    foreach (p; pi) {
      if (i - p < 2) break;
      ai[gi[i - p]] = true;
    }
    gi[i] = ai.countUntil!"!a".to!int;
  }

  writeln(gi[n] == 0 ? "Lose" : "Win");
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
