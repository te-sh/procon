import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1], c = rd[2];

  auto d = c / (a + b - 1);
  auto e = c % (a + b - 1);

  writeln(e <= a - 1 ? d * a + e : d * a + a);
}
