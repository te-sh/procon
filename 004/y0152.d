import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.numeric;   // gcd

const auto p = 1000003;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!long;

  l /= 4;
  auto maxM = (l / 2).to!real.sqrt.to!long;

  auto r = 0;
  foreach (long m; iota(1, l.to!real.sqrt.to!long + 1))
    foreach (long n; iota(m % 2 + 1, m, 2)) {
      if (2L * m * (m + n) > l) break;
      if (gcd(m, n) == 1) ++r;
    }

  writeln(r % p);
}
