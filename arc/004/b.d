import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto d = new int[](n);
  foreach (i; 0..n) d[i] = readln.chomp.to!int;

  auto ma = d.sum;
  auto mi = max(0, d.reduce!max * 2 - ma);

  writeln(ma);
  writeln(mi);
}
