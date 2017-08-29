import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp;
  writeln(a == "a" ? "-1" : "a");
}
