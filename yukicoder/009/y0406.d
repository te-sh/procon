import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto x = readln.split.to!(int[]);

  x.sort();

  auto y = new int[](n-1);
  foreach (i; 0..n-1) y[i] = x[i+1] - x[i];

  writeln(y[0] > 0 && y.uniq.walkLength == 1 ? "YES" : "NO");
}
