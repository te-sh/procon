import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto x = readln.chomp;
  auto s = readln.chomp;

  writeln(s.replace(x, ""));
}
