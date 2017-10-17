import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;
  auto c = new int[](3);
  foreach (si; s) ++c[si.predSwitch('R', 0, 'G', 1, 'B', 2)];
  writeln(c.filter!"a % 2".walkLength);
}
