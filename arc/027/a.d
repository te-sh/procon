import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], m = rd[1];
  writeln(18*60-(h*60+m));
}
