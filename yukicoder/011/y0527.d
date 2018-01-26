import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  auto v = new int[](n), w = new int[](n);
  foreach (i; 0..n) readV(v[i], w[i]);
  int vs; readV(vs);

  auto ws = w.sum;
  auto dp = new int[][](n+1, ws+1);
  foreach (i; 0..n+1) dp[i][] = -1;
  dp[0][0] = 0;

  foreach (i; 0..n)
    foreach (j; 0..ws+1) {
      dp[i+1][j] = dp[i][j];
      if (j >= w[i] && dp[i][j-w[i]] >= 0)
        dp[i+1][j] = max(dp[i+1][j], dp[i][j-w[i]]+v[i]);
    }

  auto m1 = false, m2 = false;
  foreach (i; 0..ws+1) {
    if (dp[n][i] == vs && !m1) {
      m1 = true;
      writeln(max(i, 1));
    }
    if (dp[n][i] > vs && !m2) {
      m2 = true;
      writeln(i-1);
    }
  }

  if (!m2) writeln("inf");
}
