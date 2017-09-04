import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp;
  auto b = readln.chomp;
  writeln(a.length > b.length ? a : b);
}
