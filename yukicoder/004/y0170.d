import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  auto fi = new int[](s.length + 1);
  fi[0] = 1;
  foreach (i; 1..fi.length) fi[i] = i.to!int * fi[i - 1];

  auto hi = new int[](26);
  foreach (c; s) ++hi[c - 'A'];

  auto r = fi[s.length];
  foreach (h; hi) r /= fi[h];

  writeln(r - 1);
}
