import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  writeln("2018", s[4..$]);
}
