import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;
  auto t = readln.chomp;
  writeln(zip(s, t).count!"a[0] != a[1]");
}
