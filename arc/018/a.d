import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(real[]), h = rd[0], b = rd[1];
  writefln("%.3f", b * (h/100) ^^ 2);
}
