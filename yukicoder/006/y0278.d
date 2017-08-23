import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;

  auto y = n % 2 ? n : n / 2;
  auto my = y.to!real.sqrt.to!long + 1;

  auto r = 0L;
  foreach (s; 1..my+1) {
    if (y % s == 0) {
      r += s;
      auto t = y / s;
      if (s != t) {
        r += t;
      }
    }
  }

  writeln(r);
}
