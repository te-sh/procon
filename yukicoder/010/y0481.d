import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto b = readln.split.to!(int[]);
  auto c = new bool[](11); c[0] = true;
  foreach (bi; b) c[bi] = true;
  writeln(c.countUntil(false));
}
