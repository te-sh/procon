import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), d = rd[0], p = rd[1];

  writeln(d * (100 + p) / 100);
}
