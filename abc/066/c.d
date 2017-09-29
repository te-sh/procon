// path: arc077_a

import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!ptrdiff_t;
  auto a = readln.split.to!(int[]);

  if (n == 1) {
    write(a[0]);
  } else if (n % 2 == 0) {
    for (auto i = n-1; i >= 1; i -= 2) write(a[i], " ");
    for (auto i = 0; i <= n-2; i += 2) write(a[i], i == n-2 ? "" : " ");
  } else {
    for (auto i = n-1; i >= 0; i -= 2) write(a[i], " ");
    for (auto i = 1; i <= n-2; i += 2) write(a[i], i == n-2 ? "" : " ");
  }

  writeln;
}
