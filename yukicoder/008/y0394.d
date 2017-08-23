import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.split.to!(int[]);
  s.sort();
  writefln("%.2f", s[1..$-1].sum.to!real / (s.length-2));
}
