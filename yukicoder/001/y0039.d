import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto ni = readln.chomp.split("").map!(to!int).array;
  writeln(calc(ni).map!(to!string).join(""));
}

auto calc(int[] ni)
{
  foreach (i, n; ni[0..$-1]) {
    auto ti = ni.drop(i + 1);
    auto ma = ti.reduce!max;
    if (ma > n) {
      auto j = ti.retro.countUntil(ma);
      swap(ni[i], ti[$-j-1]);
      return ni;
    }
  }
  return ni;
}
