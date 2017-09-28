import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto c = new int[](26);
  foreach (si; s) ++c[si-'a'];
  writeln(c.all!"a<2" ? "yes" : "no");
}
