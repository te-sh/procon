import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], s = rd[2];

  auto calc() {
    if (s == 1 || (s - a).abs <= (s - b).abs)
      return (s - a).abs + s;

    auto m1 = a > 0 ? (s - b).abs + (s - a).abs + a : int.max;
    auto m2 = (s - b).abs + (s - 1) + (a - 1).abs + 1;
    return min(m1, m2);
  }

  writeln(calc);
}
