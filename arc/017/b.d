import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];
  auto a = new int[](n);
  foreach (i; 0..n) a[i] = readln.chomp.to!int;

  auto b = new int[](n);
  foreach (i; 0..n-1) b[i+1] = b[i] + (a[i]>=a[i+1]);

  auto ans = 0;
  foreach (i; 0..n-k+1)
    ans += b[i+k-1]-b[i] == 0;

  writeln(ans);
}
