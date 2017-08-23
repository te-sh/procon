import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto s = ai.sum / (n - 1);
  auto bi = ai.map!(a => s - a);

  writeln(bi.count!"a == 2", " ", bi.count!"a == 4");
}
