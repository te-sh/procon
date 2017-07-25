import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];
  auto c = b - a;

  if (c == 0) writeln(0);
  else        writefln("%+d", c);
}
