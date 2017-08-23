import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rgb = readln.split.to!(int[]);

  auto canMake(int a, int _) {
    auto l = rgb.filter!(b => b < a).map!(b => a - b).sum;
    auto e = rgb.filter!(b => b > a).map!(b => (b - a) / 2).sum;
    return l <= e;
  }

  if (rgb.sum == 0)
    writeln(0);
  else
    writeln(rgb.sum.iota.assumeSorted!canMake.lowerBound(0).back);
}
