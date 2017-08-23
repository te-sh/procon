import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto b = readln.chomp.to!long;
  auto n = readln.chomp.to!size_t;
  auto ci = n.iota.map!(_ => readln.chomp).array.to!(long[]);

  ci.sort();

  auto k = n % 2 ? ci[n / 2] : (ci[n / 2 - 1] + ci[n / 2]) / 2;
  k = min(k, (ci.sum + b) / n);

  writeln(ci.map!(c => (c - k).abs).sum);
}
