import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto l = readln.chomp.to!long * 2;
  auto x = (n-1).iota.map!(_ => readln.chomp.to!long * 2).array;
  x = 0 ~ x;

  foreach (i; 1..n)
    if (x[i] >= x[i-1] + l || x[i] + l <= x[i-1]) {
      writeln(-1);
      return;
    }

  auto sg = (x[$-1] * 2 + l) / 2, r = 0;
  foreach (i; 1..n.to!long) {
    auto xi0 = x[$-1-i], xi1 = x[$-i];
    if (sg <= xi0 * i || sg >= (xi0 + l) * i || sg <= xi1 * i || sg >= (xi1 + l) * i) ++r;
    sg += (xi0 * 2 + l) / 2;
  }

  writeln(r);
}
