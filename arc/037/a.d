import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto m = readln.split.to!(int[]);
  writeln(m.map!(mi => max(0, 80-mi)).sum);
}
