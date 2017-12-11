import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], k = rd[1];
  writeln(n/(k+1)+1);
}
