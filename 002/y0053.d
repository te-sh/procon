import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -9

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  writefln("%.10f", (3.to!real / 4) ^^ n * 4);
}
