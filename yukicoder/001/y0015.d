import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, s = rd[1].to!uint;
  auto pi = n.iota.map!(_ => readln.chomp.to!uint).array;

  auto pi1 = pi.take(n / 2), pi2 = pi.drop(n / 2);
  auto si1 = pi1.sumTable, si2 = pi2.sumTable;

  auto bsi2 = si2.enumerate.map!(a => bitSum(a[0], a[1])).array;
  bsi2.sort!"a.sum < b.sum";

  size_t[][] ri;
  foreach (i, s1; si1) {
    auto ar1 = i.bitsSet.array;
    auto ari2 = bsi2
      .assumeSorted!"a.sum < b.sum"
      .equalRange(bitSum(0, s - s1))
      .map!(a => a.b.bitsSet.map!(a => a + n / 2).array);
    foreach (ar2; ari2) ri ~= ar1 ~ ar2;
  }

  ri.sort();
  foreach (r; ri)
    writeln(r.map!"a + 1".map!(to!string).join(" "));
}

struct bitSum {
  size_t b;
  uint sum;
}

auto sumTable(uint[] pi)
{
  auto n = pi.length;
  return (1 << n).iota.map!(i => pi.indexed(i.bitsSet).sum).array;
}
