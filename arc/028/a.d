import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], a = rd[1], b = rd[2];
  n %= a+b;

  writeln(n >= 1 && n <= a ? "Ant" : "Bug");
}
