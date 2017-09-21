import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, a = rd[0].to!int, op = rd[1], b = rd[2].to!int;
  writeln(op == "+" ? a+b : a-b);
}
