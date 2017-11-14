import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto s = new long[](n);
  foreach (i; 0..n) s[i] = readln.chomp.to!long;
  auto c = new int[][](n), p = new int[](n);
  foreach (i; 0..n-1) {
    auto rd = readln.splitter;
    auto a = rd.front.to!int-1; rd.popFront();
    auto b = rd.front.to!int-1;
    c[a] ~= b;
    p[b] = a;
  }
  auto m = readln.chomp.to!int;
  auto t = new long[](m);
  foreach (i; 0..m) t[i] = readln.chomp.to!long;

  auto nd = new int[](n), dp = new long[][](n, n+1);
  auto inf = 10L^^16;
  foreach_reverse (i; 0..n) {
    nd[i] = 1;
    foreach (ci; c[i]) nd[i] += nd[ci];

    auto dp2 = new long[](nd[i]+1), dp3 = new long[](nd[i]+1);
    dp2[] = inf;
    dp2[0] = 0; dp2[1] = s[i];
    foreach (ci; c[i]) {
      dp3[] = dp2[];
      foreach (j; 1..nd[ci]+1)
        foreach_reverse (k; 1..nd[i]-j+1)
          dp3[j+k] = min(dp2[j+k], dp2[k] + dp[ci][j]);
      dp2[] = dp3[];
    }
    dp[i][0..nd[i]+1] = dp2[];
  }

  t.sort!"a > b";

  auto ans = 0L, ss = s.sum, st = 0L;
  foreach (i; 0..min(n+1, m)) {
    ans = max(ans, ss - dp[0][i] + st);
    st += t[i];
  }
  writeln(ans);
}
