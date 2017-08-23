import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1], r = rd[2];
  auto a = (r.to!real / SQRT2 * 2).ceil.to!int;
  writeln(x.abs + y.abs + a);
}
