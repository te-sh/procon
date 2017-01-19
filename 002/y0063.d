import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), l = rd[0], k = rd[1];

  if (l % 2 == 1 || (l / 2) % k != 0)
    writeln(l / 2 / k * k);
  else
    writeln(l / 2 / k * k - k);
}
