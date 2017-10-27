import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  writeln(h > w ? "TATE" : "YOKO");
}
