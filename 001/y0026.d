import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int - 1;
  auto m = readln.chomp.to!size_t;

  auto ci = new bool[](3);
  ci[n] = true;

  foreach (_; m.iota) {
    auto rd = readln.split.to!(int[]), p = rd[0] - 1, q = rd[1] - 1;
    swap(ci[p], ci[q]);
  }

  auto r = ci.countUntil!"a".to!int + 1;
  writeln(r);
}
