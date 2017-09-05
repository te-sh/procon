import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.split.to!(int[]);
  a.sort();
  writeln(a[1]);
}
