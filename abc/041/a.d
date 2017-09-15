import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  auto i = readln.chomp.to!size_t-1;
  writeln(s[i]);
}
