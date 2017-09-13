import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, k = rd[1].to!int;
  auto s = new int[](n);
  foreach (i; 0..n) s[i] = readln.chomp.to!int;

  if (s.canFind(0)) {
    writeln(n);
    return;
  }

  size_t i = 0, j = 0, m = 0;
  auto p = 1L;

  while (j < n) {
    p *= s[j];
    if (p <= k) {
      m = max(m, j-i+1);
      ++j;
    } else {
      if (i == j) {
        ++i;
        ++j;
        p = 1;
      } else {
        while (i < j && p > k) {
          p /= s[i];
          ++i;
        }
        p /= s[j];
      }
    }
  }

  writeln(m);
}
