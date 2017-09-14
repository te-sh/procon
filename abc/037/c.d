import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], k = rd[1];
  auto a = readln.split.to!(long[]);

  auto c = new long[](n+1);
  c[1..$][] = a[];
  foreach (i; 0..n) c[i+1] += c[i];

  auto ans = 0L;
  foreach (i; 0..n-k+1)
    ans += c[i+k] - c[i];

  writeln(ans);
}
