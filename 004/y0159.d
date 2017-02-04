import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(real[]), p = rd[0], q = rd[1];
  auto p1 = 1 - p;
  auto p2 = p * (1 - q);
  writeln(p1 < p2 ? "YES" : "NO");
}
