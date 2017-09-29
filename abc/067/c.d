// path: arc078_a

import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(long[]);

  auto c1 = new long[](n), c2 = new long[](n);

  c1[0] = a[0];
  foreach (i; 1..n) c1[i] = a[i] + c1[i-1];

  c2[n-1] = a[n-1];
  foreach_reverse (i; 0..n-1) c2[i] = c2[i+1] + a[i];

  auto ans = long.max;
  foreach (i; 0..n-1)
    ans = min(ans, (c1[i] - c2[i+1]).abs);

  writeln(ans);
}
