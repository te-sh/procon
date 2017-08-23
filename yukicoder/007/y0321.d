import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.numeric;   // gcd, fft

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(long[]), p = rd1[0], q = rd1[1];
  auto n = readln.chomp.to!size_t;

  auto g1 = (p != 0 || q != 0) ? gcd(p, q) : 0;
  if (g1 != 0) { p /= g1; q /= g1; }

  auto g2 = (p != 0 || q != 0) ? gcd((p ^^ 2 - q ^^ 2).abs, 2 * q) : 0;

  auto r = 0;
  foreach (_; 0..n) {
    auto rd2 = readln.split.to!(long[]), x = rd2[0], y = rd2[1];

    if (g1 != 0) {
      if (x % g1 != 0 || y % g1 != 0) continue;
      x /= g1; y /= g1;
    }

    if (p == 0 && q == 0) {
      if (x == 0 && y == 0) ++r;
    } else if (p == 1 && q == 1) {
      if (x == y) ++r;
    } else if (p == 0 || q == 0 || g2 == 1) {
      ++r;
    } else {
      if ((q * y - p * x) % g2 == 0) ++r;
    }
  }

  writeln(r);
}
