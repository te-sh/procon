import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.numeric;   // gcd

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto bi = [ai.front]; ai = ai.drop(1);

  while (!ai.empty) {
    auto i = calcMin(ai, bi.back);
    bi ~= ai[i];
    ai = ai.remove(i);
  }

  writeln(bi.to!(string[]).join(" "));
}

auto calcMin(Range)(Range ai, int b)
{
  auto minLcm = int.max, minA = 0, minIndex = size_t(0);
  foreach (i, a; ai) {
    auto lcm = a / gcd(a, b) * b;
    if (minLcm > lcm || minLcm == lcm && minA > a) {
      minLcm = lcm;
      minA = a;
      minIndex = i;
    } 
  }
  return minIndex;
}
