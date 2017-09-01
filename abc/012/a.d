import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  writeln(rd[1], " ", rd[0]);
}
