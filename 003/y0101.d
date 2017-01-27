import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto k = readln.chomp.to!size_t;
  auto bi = k.iota.map!(_ => readln.split.to!(size_t[]).front - 1).array;

  auto ci = new size_t[](n);
  foreach (i; n.iota) {
    auto j = i;
    foreach (b; bi) {
      if (j == b) ++j;
      else if (j == b + 1) --j;
    }
    ci[i] = j;
  }

  auto di = new int[](n);
  foreach (i; n.iota) {
    auto j = i, d = 0;
    do {
      j = ci[j];
      ++d;
    } while (j != i);
    di[i] = d;
  }

  writeln(di.fold!((a, b) => a / gcd(a, b) * b));
}
