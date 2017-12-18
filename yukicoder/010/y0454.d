import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = 10^^5;
  auto x = readln.chomp.to!real;

  auto r = 0.0L;
  foreach (i; 1..n)
    r += 1.0L/(x+i)^^2;

  writefln("%.10f", r+1.0L/(x+n));
}
