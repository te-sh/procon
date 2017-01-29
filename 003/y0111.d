import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!long;
  writeln(((l - 1) / 2) ^^ 2);
}
