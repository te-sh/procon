import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!long;
  long[] ans;
  foreach (x; max(1, n-162)..n)
    if (x + f(x) == n) ans ~= x;

  writeln(ans.length);
  foreach (a; ans) writeln(a);
}

auto f(long x)
{
  auto r = 0L;
  for (; x > 0; x /= 10) r += x % 10;
  return r;
}
