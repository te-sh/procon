import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto c = new int[](n);
  foreach (i; 0..n) c[i] = readln.chomp.to!int;

  auto g = c.group.map!"a[1]".array;
  if (g.length == 1) {
    writeln(-1);
    return;
  }

  if (c[0] == c[$-1]) {
    g[0] += g[$-1];
    g = g[0..$-1];
  }

  auto m = g.reduce!max;
  writeln((m+1)/2);
}
