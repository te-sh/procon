import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;

  a = a.sort!"a>b".uniq.array;
  writeln(a[1]);
}
