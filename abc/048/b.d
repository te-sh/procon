import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), a = rd[0], b = rd[1], x = rd[2];

  if (a > 0)
    writeln(b/x - (a-1)/x);
  else
    writeln(b/x + 1);
}
