import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  m += n * 60;

  auto d = 55 * m % 3600;
  if (d > 1800) d = 3600 - d;

  writefln("%.1f", d.to!real / 10);
}
