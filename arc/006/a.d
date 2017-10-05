import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto e = readln.split.to!(int[]);
  auto b = readln.chomp.to!int;
  auto l = readln.split.to!(int[]);

  auto r = setIntersection(e, l).walkLength;
  if      (r == 6) writeln(1);
  else if (r == 5) writeln(l.canFind(b) ? 2 : 3);
  else if (r == 4) writeln(4);
  else if (r == 3) writeln(5);
  else             writeln(0);
}
