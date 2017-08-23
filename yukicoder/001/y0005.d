import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!int;
  auto n = readln.chomp.to!size_t;
  auto wi = readln.split.to!(int[]);

  wi.sort();

  writeln(calc(l, wi));
}

auto calc(int l, int[] wi)
{
  int a = 0;
  foreach (i, w; wi) {
    a += w;
    if (a > l) return i;
  }
  return wi.length;
}
