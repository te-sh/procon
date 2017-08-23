import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!int, p = rd[1].to!real;

  auto di = divisors(n);
  auto r = real(0);
  foreach (d; di)
    r += (1 - p) ^^ d;

  writefln("%.7f", r);
}

int[] divisors(int n)
{
  auto di = new int[](n + 1);
  foreach (i; 2..n/2+1)
    foreach (j; iota(i * 2, n + 1, i))
      ++di[j];
  return di[2..$];
}
