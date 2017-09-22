import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  auto pa = a == 1 ? 14 : a, pb = b == 1 ? 14 : b;
  if (pa == pb)     writeln("Draw");
  else if (pa > pb) writeln("Alice");
  else              writeln("Bob");
}
