import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto p = readln.split.to!(int[]);
  p.sort();
  writeln(p[0..2].sum);
}
