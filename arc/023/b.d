import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), r = rd[0], c = rd[1], d = rd[2];
  auto a = new int[][](r, c);
  foreach (i; 0..r) a[i] = readln.split.to!(int[]);

  auto ans = 0;
  foreach (i; 0..r)
    foreach (j; 0..c)
      if (i+j <= d && (i+j)%2 == d%2)
        ans = max(ans, a[i][j]);

  writeln(ans);
}
