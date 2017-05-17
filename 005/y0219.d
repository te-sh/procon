import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  foreach (_; 0..n) {
    auto rd = readln.split.to!(real[]), a = rd[0], b = rd[1];
    auto c = b * log10(a);
    auto z = c.floor, w = c - z;
    auto d = 10 ^^ w;
    auto x = d.floor, y = ((d - x) * 10).floor;

    writefln("%d %d %d", x.to!long, y.to!long, z.to!long);
  }
}
