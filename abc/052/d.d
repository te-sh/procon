import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, a = rd[1].to!long, b = rd[2].to!long;
  auto x = readln.split.to!(long[]);

  auto ans = 0L;
  foreach (i; 0..n-1)
    ans += min((x[i+1]-x[i])*a, b);

  writeln(ans);
}
