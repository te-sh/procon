import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], c = rd[2], d = rd[3];
  auto ta = b * c, ao = a * d;
  if (ta == ao)     writeln("DRAW");
  else if (ta > ao) writeln("TAKAHASHI");
  else              writeln("AOKI");
}
