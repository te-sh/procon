import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), x = rd[0], a = rd[1], b = rd[2];
  if (b-a <= 0)
    writeln("delicious");
  else if (b-a <= x)
    writeln("safe");
  else
    writeln("dangerous");
}
