import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto c = new int[](6);
  foreach (_; 0..n) {
    auto rd = readln.split.to!(real[]), ma = rd[0], mi = rd[1];
    if (ma >= 35) ++c[0];
    if (ma >= 30 && ma < 35) ++c[1];
    if (ma >= 25 && ma < 30) ++c[2];
    if (mi >= 25) ++c[3];
    if (ma >= 0 && mi < 0) ++c[4];
    if (ma < 0) ++c[5];
  }

  writeln(c.to!(string[]).join(" "));
}
