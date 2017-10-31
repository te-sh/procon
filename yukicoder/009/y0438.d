import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), x = rd[0], y = rd[1], z = rd[2];
  writeln(calc(x, y, z));
}

auto calc(long x, long y, long z)
{
  if (z == 0) return "ccW";
  if (x == 0 && y == 0) return "NO";

  if (x == 0) {
    if (z % y) return "NO";
    auto g = z/y;
    if (g*2-1 > 10000) return "NO";
    return 'w'.repeat.take(g).chain('C'.repeat.take(g-1)).to!string;
  }
  if (y == 0) {
    if (z % x) return "NO";
    auto g = z/x;
    if (g*2-1 > 10000) return "NO";
    return 'c'.repeat.take(g).chain('C'.repeat.take(g-1)).to!string;
  }

  auto ma = 100000L, mb = 100000L;
  foreach (a; -5000L..5001L) {
    if ((z-a*x)%y) continue;
    auto b = (z-a*x)/y;

    if (a.abs*2+b.abs*2-1 > 10000) continue;

    if (a.abs*2+b.abs*2-1 < ma.abs*2+mb.abs*2-1) {
      ma = a;
      mb = b;
    }
  }

  if (ma.abs*2+mb.abs*2 > 10000) return "NO";

  if (ma == 0)
    return 'w'.repeat.take(mb).chain('C'.repeat.take(mb-1)).to!string;
  if (mb == 0)
    return 'c'.repeat.take(ma).chain('C'.repeat.take(ma-1)).to!string;

  if (ma < 0)
    return 'c'.repeat.take(-ma).chain('C'.repeat.take(-ma-1))
      .chain('w'.repeat.take(mb).chain('C'.repeat.take(mb-1))).to!string ~ "W";
  if (mb < 0)
    return 'w'.repeat.take(-mb).chain('C'.repeat.take(-mb-1))
      .chain('c'.repeat.take(ma).chain('C'.repeat.take(ma-1))).to!string ~ "W";

  return 'c'.repeat.take(ma).chain('C'.repeat.take(ma-1))
    .chain('w'.repeat.take(mb)).chain('C'.repeat.take(mb)).to!string;
}
