import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto v1 = readln.chomp.split(".").to!(int[]);
  auto v2 = readln.chomp.split(".").to!(int[]);
  writeln(v1 >= v2 ? "YES" : "NO");
}
