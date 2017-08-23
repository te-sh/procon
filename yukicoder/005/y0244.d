import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  writeln(readln.chomp.to!int - 1);
}
