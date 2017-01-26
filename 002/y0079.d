import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto li = readln.split.to!(int[]);

  auto lcs = 6.iota.map!(i => LvCount(i + 1, 0)).array;
  foreach (l; li) ++lcs[l - 1].cnt;

  lcs.sort!"a.cnt != b.cnt ? a.cnt > b.cnt : a.lv > b.lv";

  writeln(lcs.front.lv);
}

struct LvCount
{
  int lv, cnt;
}
