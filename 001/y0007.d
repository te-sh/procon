import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  auto pi = primes(n);
  auto gi = new int[](n + 1);
  auto ai = new bool[](n);

  foreach (int i; 4..(n + 1)) {
    ai[] = false;
    foreach (p; pi) {
      if (i - p < 2) break;
      ai[gi[i - p]] = true;
    }
    gi[i] = ai.countUntil!"!a".to!int;
  }

  writeln(gi[n] == 0 ? "Lose" : "Win");
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
