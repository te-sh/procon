import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto b = readln.chomp.map!(bi => cast(int)(bi - '0')).array;
  auto n = readln.chomp.to!long;

  auto dp = new int[][][](10, 82);
  foreach (bi; b) dp[1][bi] = [bi];
  foreach (i; 2..10)
    foreach (j; 0..82)
      foreach (bi; b)
        if (j >= bi && !dp[i-1][j-bi].empty) {
          dp[i][j] = dp[i-1][j-bi] ~ bi;
          break;
        }
  auto dpm = dp[9];

  int[][][long] memo;

  int[][] calc(long n)
  {
    if (n == 0) return [dpm[0]];
    if (n in memo) return memo[n];

    auto m = n % 10, mil = int.max;
    int[][] mir;
    for (auto k = m; k <= 81; k += 10) {
      if (n >= k && !dpm[k].empty) {
        auto r = calc((n - k) / 10);
        if (r.empty) continue;
        r ~= dpm[k];
        auto l = calcLen(r);
        if (l < mil) {
          mil = l;
          mir = r;
        }
      }
    }

    return memo[n] = mir;
  }

  auto r = calc(n), nr = r[0].length, ans = new long[](nr+1);
  foreach (ri; r)
    foreach (i; 0..nr)
      ans[i] = ans[i] * 10 + ri[i];

  foreach (i; 0..nr) {
    if (ans[i] == 0) break;
    if (ans[i] > 0) write(ans[i]);
    if (ans[i+1] > 0) write("+");
    if (ans[i+1] == 0 && i > 0) writeln("=");
  }
}

int calcLen(int[][] r)
{
  auto n = r[0].length, l = 0, b = new bool[](n);
  foreach (ri; r)
    foreach (i; 0..n) {
      if (ri[i] > 0) b[i] = true;
      if (b[i]) ++l;
    }

  auto c = b.count!"a".to!int;
  if (c == 0) return 0;
  if (c == 1) return l;
  else return l + c;
}
