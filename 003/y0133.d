import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);
  auto bi = readln.split.to!(int[]);

  auto c = bi.permutations.count!(ci => zip(ai, ci).count!"a[0] > a[1]" > n / 2);
  writefln("%.3f", c.to!real / n.to!int.iota.map!"a + 1".fold!"a * b");
}
