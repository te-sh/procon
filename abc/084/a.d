import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!int;
  writeln(48-m);
}
