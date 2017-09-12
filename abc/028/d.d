import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], k = rd[1];
  auto c = 1 + (n-1) * 3 + (k-1) * (n-k) * 6;
  writefln("%.10f", c.to!real / n ^^ 3);
}
