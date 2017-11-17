import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), na = rd[0], nb = rd[1];
  auto a = readln.split.to!(int[]);
  auto b = readln.split.to!(int[]);

  int[int] buf;
  foreach (ai; a) ++buf[ai];
  foreach (bi; b) ++buf[bi];

  auto its = 0, uni = 0;
  foreach (c; buf.byValue) {
    ++uni;
    if (c >= 2) ++its;
  }

  writefln("%.7f", its.to!real / uni);
}
