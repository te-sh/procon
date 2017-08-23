import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, v = rd[0][2..$].to!int, t = rd[1].to!int;
  writeln(v * t / 10000);
}
