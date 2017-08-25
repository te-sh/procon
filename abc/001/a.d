import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto h1 = readln.chomp.to!int;
  auto h2 = readln.chomp.to!int;
  writeln(h1 - h2);
}
