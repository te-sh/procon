import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto b = a.filter!"a>0".array, sb = b.sum, sn = b.length;
  writeln((sb + sn - 1) / sn);
}
