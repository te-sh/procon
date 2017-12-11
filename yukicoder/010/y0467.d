import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto d = readln.split.to!(int[]), dm = d.maxElement;
  auto rd = readln.split.to!(int[]), x = rd[0].abs, y = rd[1].abs;

  auto z = max(x, y);
  auto r = (max(z-dm*2, 0) + dm - 1) / dm;
  z -= r * dm;

  if (d.canFind(z)) r += 1;
  else if (z > 0)   r += 2;

  writeln(r);
}
