import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -12

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], g = rd[1], v = rd[2];
  writefln("%.13f", (n/5).to!real / v * g);
}
