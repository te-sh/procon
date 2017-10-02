// path: arc079_b

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto k = readln.chomp.to!long, n = 50;

  auto kd = k/n, km = k%n;
  auto a = new long[](n);
  a[] = n-1+kd;
  foreach (i; 0..km) {
    a[] -= 1;
    a[i] += n+1;
  }

  writeln(n);
  foreach (i, ai; a)
    write(ai, i < n-1 ? " " : "");
  writeln;
}
