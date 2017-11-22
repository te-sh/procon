import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto s = new string[](h);
  foreach (i; 0..h) s[i] = readln.chomp;

  auto g = new int[][](h, w);
  foreach_reverse (i; 0..h)
    foreach_reverse (j; 0..w) {
      if (s[i][j] != '#') {
        auto m = new bool[](4);
        if (i < h-1 && s[i+1][j] != '#') m[g[i+1][j]] = true;
        if (j < w-1 && s[i][j+1] != '#') m[g[i][j+1]] = true;
        if (i < h-1 && j < w-1 && s[i+1][j+1] != '#') m[g[i+1][j+1]] = true;
        g[i][j] = m.countUntil(false).to!int;
      }
    }

  writeln(g[0][0] == 0 ? "Second" : "First");
}
