import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = 4;
  auto a = new int[][](n, n);
  foreach (i; 0..n) a[i] = readln.split.to!(int[]);

  foreach (i; 0..n)
    foreach (j; 0..n-1)
      if (a[i][j] == a[i][j+1]) {
        writeln("CONTINUE");
        return;
      }

  foreach (j; 0..n)
    foreach (i; 0..n-1)
      if (a[i][j] == a[i+1][j]) {
        writeln("CONTINUE");
        return;
      }

  writeln("GAMEOVER");
}
