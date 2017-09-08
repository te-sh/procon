import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], s = rd[1], t = rd[2];
  auto w = readln.chomp.to!int;
  auto a = new int[](n);
  foreach (i; 1..n) a[i] = readln.chomp.to!int;

  auto r = 0;
  foreach (ai; a) {
    w += ai;
    if (w >= s && w <= t) ++r;
  }

  writeln(r);
}
