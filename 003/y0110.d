import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto nw = readln.chomp.to!size_t;
  auto wi = readln.split.to!(int[]);
  auto nb = readln.chomp.to!size_t;
  auto bi = readln.split.to!(int[]);

  auto wi2 = wi.sort().assumeSorted;
  auto bi2 = bi.sort().assumeSorted;

  writeln(max(calc(wi2, bi2), calc(bi2, wi2)));
}

auto calc(SR)(SR ai, SR bi)
{
  if (ai.empty) return 0;

  auto h = 1, r = ai.back;
  for (;; ++h) {
    auto s = bi.lowerBound(r);
    if (s.empty) break;
    r = s.back;
    swap(ai, bi);
  }
  return h;
}
