import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];
  auto k = readln.chomp.to!int;
  if (k <= y)
    writeln(x + k);
  else
    writeln(x + y - (k - y));
}
