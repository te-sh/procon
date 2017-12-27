import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], a = rd[1], b = rd[2];
  writeln(min(a*n, b));
}
