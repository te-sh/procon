import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];
  auto d = new int[](m);
  foreach (i; 0..m) d[i] = readln.chomp.to!int;

  auto d1 = d.filter!"a > 0".array.sort().array;
  auto d2 = d.filter!"a < 0".map!"-a".array.sort().array;

  if (d.canFind(0)) --n;

  if (n == 0) {
    writeln(0);
    return;
  }

  writeln(min(calc(n, d1, d2), calc(n, d2, d1)));
}

auto calc(int n, int[] a, int[] b)
{
  auto r = int.max;

  foreach (i; 1..min(a.length, n)+1) {
    auto ri = a[i-1];
    if (i == n) {
      r = min(r, ri);
    } else if (0 < n-i && n-i <= b.length) {
      ri += a[i-1] + b[n-i-1];
      r = min(r, ri);
    }
  }

  return r;
}
