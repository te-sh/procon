import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], a = rd[1], d = rd[2];
  auto ei = new int[](h + 1);

  foreach (i; 1..h+1)
    ei[i] = min(ei[clamp(i - a, 0, i)] + 10, ei[clamp(i - d, 0, i)] + 15);

  writeln(ei[h].to!real / 10);
}
