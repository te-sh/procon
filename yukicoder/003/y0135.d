import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto xi = readln.split.to!(int[]);

  auto calc() {
    auto yi = xi.sort().uniq.array, yl = yi.length;
    if (yl == 1) return 0;
    auto zi = new int[](yl - 1);
    foreach (i; (yl - 1).iota) zi[i] = yi[i + 1] - yi[i];
    return zi.fold!min;
  }

  writeln(calc);
}
