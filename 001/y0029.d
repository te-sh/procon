import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto ai = new int[](10);
  foreach (_; n.iota) {
    auto bi = readln.split.to!(int[]);
    foreach (b; bi) ai[b - 1]++;
  }

  auto r = 0;
  foreach (ref a; ai) {
    r += a / 2;
    a %= 2;
  }

  r += ai.sum / 4;

  writeln(r);
}
