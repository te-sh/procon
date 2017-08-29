import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10007;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto a = new int[](max(4, n+1));
  a[3] = 1;

  foreach (i; 4..n+1)
    (a[i] = a[i-3] + a[i-2] + a[i-1]) %= mod;

  writeln(a[n]);
}
