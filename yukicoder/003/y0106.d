import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];

  auto sieve = new int[](n + 1);

  foreach (p; iota(2, n + 1))
    if (sieve[p] == 0)
      foreach (q; iota(p, n + 1, p))
        ++sieve[q];

  writeln(sieve.count!(a => a >= k));
}
