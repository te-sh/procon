import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto c = readln.chomp.to!int;
  auto v = readln.chomp.to!size_t;
  auto si = readln.split.to!(size_t[]);
  auto ti = readln.split.to!(size_t[]);
  auto yi = readln.split.to!(int[]);
  auto mi = readln.split.to!(int[]);

  auto tij = new size_t[][](n);
  auto yij = new int[][](n);
  auto mij = new int[][](n);
  foreach (i; v.iota) {
    auto j = si[i] - 1;
    tij[j] ~= ti[i] - 1;
    yij[j] ~= yi[i];
    mij[j] ~= mi[i];
  }

  auto dp = new int[int][](n);
  dp[0][0] = 0;

  foreach (i; 0..n-1) {
    foreach (t, y, m; lockstep(tij[i], yij[i], mij[i])) {
      foreach (k; dp[i].byKeyValue) {
        auto ny = k.key + y;
        auto nm = k.value + m;
        if (ny <= c) {
          if (ny in dp[t])
            dp[t][ny] = min(dp[t][ny], nm);
          else
            dp[t][ny] = nm;
        }
      }
    }
  }

  auto ri = dp[n - 1].values;
  if (ri.empty)
    writeln(-1);
  else
    writeln(ri.reduce!min);
}
