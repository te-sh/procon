import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = 7;
  auto d = readln.split.to!(int[]);
  auto j = readln.split.to!(int[]);

  auto ans = 0;
  foreach (i; 0..n)
    ans += max(d[i], j[i]);

  writeln(ans);
}
