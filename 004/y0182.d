import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  int[int] hi;
  foreach (a; ai) ++hi[a];

  writeln(hi.values.filter!"a == 1".array.length);
}
