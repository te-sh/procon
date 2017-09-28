import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], c = a+b;
  if (c >= 10) writeln("error");
  else         writeln(c);
}
