import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], p = rd[1];
  writeln(p == n * p ? "=" : "!=");
}
