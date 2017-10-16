import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  auto n = rd[0].to!size_t;
  auto va = rd[1].to!real, vb = rd[2].to!real, l = rd[3].to!real;

  foreach (_; 0..n)
    l -= (va - vb) * (l / va);

  writefln("%.7f", l);
}
