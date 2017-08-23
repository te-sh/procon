import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], x = rd[1] - 1, y = rd[2] - 1, z = rd[3] - 1;

  int[][] r;
  r = calc(n);

  auto w = r[y][x] ^ z;
  foreach (ri; r) {
    ri[] ^= w;
    ri[] += 1;
  }

  foreach (ri; r)
    writeln(ri.to!(string[]).join(' '));
}

auto calc(int n)
{
  auto r = new int[][](n, n);

  auto isTaikaku(int x, int y)
  {
    auto x4 = x % 4, y4 = y % 4;
    return ((x4 == 0 || x4 == 3) && (y4 == 0 || y4 == 3) ||
            (x4 == 1 || x4 == 2) && (y4 == 1 || y4 == 2));
  }

  foreach (y; 0..n)
    foreach (x; 0..n) {
      auto i = x + y * n;
      if (isTaikaku(x, y))
        r[y][x] = i;
      else
        r[n-1-y][n-1-x] = i;
    }

  return r;
}
