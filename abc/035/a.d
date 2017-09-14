import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), w = rd[0], h = rd[1];
  writeln(w*3 == h*4 ? "4:3" : "16:9");
}
