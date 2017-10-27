import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  a = a.abs; b = b.abs;

  writeln(a < b ? "Ant" : a > b ? "Bug" : "Draw");
}
