import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 0.01

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  writefln("%.10g", 3.5L * n);
}
