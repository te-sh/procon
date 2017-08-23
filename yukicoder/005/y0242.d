import std.algorithm, std.conv, std.range, std.stdio, std.string;

// allowable-error: 10 ** -6

const m = 99;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  writefln("%.7f", ncr(m - 5, n - 5) / ncr(m, n) * 12);
}

real ncr(int n, int r)
{
  if (r < 0 || n < r) return 0;
  return fact(n) / fact(r) / fact(n-r);
}

real fact(int n)
{
  real r = 1;
  foreach (i; 0..n)
    r *= i+1;
  return r;
}
