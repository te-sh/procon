import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto w = readln.chomp;
  auto a = new int[](26);
  foreach (c; w) ++a[cast(int)(c - 'a')];
  writeln(a.all!(ai => ai % 2 == 0) ? "Yes" : "No");
}
