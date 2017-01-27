import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto c = readln.chomp.to!real;
  auto rd = readln.split.to!(real[]), ri = rd[0], ro = rd[1];

  auto r1 = (ro - ri) / 2, r2 = (ro + ri) / 2;
  writefln("%.6f", c * 2 * PI * r2 * (PI * r1 ^^ 2));
}
