import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], h = rd[1], m = rd[2], t = rd[3];

  auto f = h * 60 + m, l = f + (n - 1) * t;

  writeln(l / 60 % 24);
  writeln(l % 60);
}
