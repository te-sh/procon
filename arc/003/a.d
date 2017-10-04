import std.algorithm, std.conv, std.range, std.stdio, std.string;

const st = [4, 3, 2, 1, 0, 0];

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto r = readln.chomp;

  auto s = 0;
  foreach (ri; r) s += st[ri - 'A'];

  writefln("%.10f", s.to!real / n);
}
