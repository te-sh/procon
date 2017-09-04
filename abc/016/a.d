import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), m = rd[0], d = rd[1];
  writeln(m % d == 0 ? "YES" : "NO");
}
