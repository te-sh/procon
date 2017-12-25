import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), gx = rd[0], gy = rd[1], n = rd[2], f = rd[3];
  struct Crystal { int x, y, c; }
  auto c = new Crystal[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(int[]), xi = rd2[0], yi = rd2[1], ci = rd2[2];
    c[i] = Crystal(xi, yi, ci);
  }

  auto dp = new int[][][](n+1, gy+1, gx+1);
  foreach (y; 0..gy+1)
    foreach (x; 0..gx+1)
      dp[0][y][x] = f*(x+y);

  foreach (i; 0..n) {
    foreach (y; 0..gy+1) dp[i+1][y][] = dp[i][y][];
    foreach (y; 0..gy+1)
      foreach (x; 0..gx+1)
        if (x >= c[i].x && y >= c[i].y)
          dp[i+1][y][x] = min(dp[i][y][x], dp[i][y-c[i].y][x-c[i].x] + c[i].c);
  }

  writeln(dp[n][gy][gx]);
}
