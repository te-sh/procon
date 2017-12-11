import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto y = readln.split.to!(int[]);
  y.sort();

  auto m = n&1 ? y[n/2] : (y[n/2-1]+y[n/2])/2;
  auto ans = 0L;
  foreach (yi; y) ans += (yi-m).abs;

  writeln(ans);
}
