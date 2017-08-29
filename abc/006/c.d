import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];

  foreach (z; 0..n+1) {
    auto x = 3 * n - m + z, y = m - 2 * n - 2 * z;
    if (0 <= x && x <= n && 0 <= y && y <= n) {
      writeln(x, " ", y, " ", z);
      return;
    }
  }

  writeln(-1, " ", -1, " ", -1);
}
