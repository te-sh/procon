import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto xi = readln.split.to!(int[]);

  auto buf = new int[](2);
  foreach (x; xi) ++buf[x.abs % 2];

  writeln((buf[0] - buf[1]).abs);
}
