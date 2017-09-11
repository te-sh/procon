import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto a = readln.chomp.to!int, r = 0;

  foreach (x; 1..a) r = max(r, x * (a-x));

  writeln(r);
}
