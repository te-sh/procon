import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), r = rd1[0], c = rd1[1], k = rd1[2]-1;
  auto s = new int[][](r, c);
  foreach (i; 0..r) {
    auto rd2 = readln.chomp;
    foreach (j; 0..c) s[i][j] = rd2[j] == 'x';
  }

  auto cs1 = new int[][](r+c-1, r);
  auto cs2 = new int[][](r+c-1, r);

  foreach (i; 0..r)
    foreach (j; 0..c) {
      cs1[i+j][i] = s[i][j];
      cs2[i-j+c-1][i] = s[i][j];
    }

  foreach (i; 0..r+c-1)
    foreach (j; 1..r) {
      cs1[i][j] += cs1[i][j-1];
      cs2[i][j] += cs2[i][j-1];
    }

  auto culSum1(int s, int i, int j)
  {
    return cs1[s][j] - (i > 0 ? cs1[s][i-1] : 0);
  }

  auto culSum2(int s, int i, int j)
  {
    return cs2[s+c-1][j] - (i > 0 ? cs2[s+c-1][i-1] : 0);
  }

  auto dp = new int[][](r, c), ans = 0;

  foreach (y; k..r-k)
    foreach (x; k..c-k) {
      if (x == k && y == k) {
        foreach (i; -k..k+1)
          foreach (j; -k..k+1)
            if (i.abs + j.abs <= k) dp[y][x] += s[y+i][x+j];
      } else if (x > k) {
        dp[y][x] = dp[y][x-1]
          - culSum1(y+x-k-1, y-k, y) - culSum2(y-x+k+1, y+1, y+k)
          + culSum2(y-x-k, y-k, y) + culSum1(y+x+k, y+1, y+k);
      } else {
        dp[y][x] = dp[y-1][x]
          - culSum1(y+x-k-1, y-k-1, y-1) - culSum2(y-x-k-1, y-k, y-1)
          + culSum2(y-x+k, y, y+k) + culSum1(y+x+k, y, y+k-1);
      }

      if (dp[y][x] == 0) ++ans;
    }

  writeln(ans);
}
