import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto tmin = long.max, tmax = 0L;

  foreach (p; 1..n) {
    if (n / p < p * p) break;
    if (n % p != 0) continue;
    auto m = n / p;
    foreach (q; p..m) {
      if (m / q < q) break;
      if (m % q != 0) continue;
      auto r = m / q;

      tmin = min(tmin, p + q + r - 3);
      tmax = max(tmax, p + q + r - 3);
    }
  }

  writeln(tmin, " ", tmax);
}
