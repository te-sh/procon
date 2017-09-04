import std.algorithm, std.conv, std.range, std.stdio, std.string;

const r = [["!", "-"], ["+", "?"]];

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], c = rd[2];
  writeln(r[a+b==c][a-b==c]);
}
