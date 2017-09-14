import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], c = rd[2];

  auto ans = 0;
  foreach (x; 0..c/a+1)
    foreach (y; 0..c/b+1)
      if (a*x+b*y <= c) ans = max(ans, x+y);

  writeln(ans);
}
