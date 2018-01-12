import std.algorithm, std.conv, std.range, std.stdio, std.string;

T read1(T)(){return readln.chomp.to!T;}
void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref ai; a)ai=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  auto n = read1!int;
  auto s = readArrayM!long(n), ss = s.sum;

  auto c = new int[][](n);
  int a, b;
  foreach (i; 0..n-1) {
    read2(a, b);
    c[--a] ~= --b;
  }

  auto m = read1!int;
  auto t = readArrayM!long(m);
  t.sort!"a > b";

  auto dp = new long[][](n, n+1), nd = new int[](n);
  foreach_reverse (i; 0..n) {
    nd[i] = c[i].map!(j => nd[j]).sum + 1;
    auto nci = c[i].length.to!int, ndi = nd[i];

    auto dp2 = new long[][](nci+1, ndi);
    foreach (j; 0..nci+1) dp2[j][] = 10L^^18;
    dp2[0][0] = 0;

    foreach (j; 0..nci) {
      auto ci = c[i][j];
      foreach (k; 0..ndi)
        foreach (l; 0..nd[ci]+1)
          if (k >= l)
            dp2[j+1][k] = min(dp2[j+1][k], dp2[j][k-l] + dp[ci][l]);
    }
    foreach (k; 0..ndi)
      dp[i][k+1] = dp2[nci][k] + s[i];
  }

  auto ans = 0L;
  foreach (i; 0..min(n, m)+1)
    ans = max(ans, ss-dp[0][i]+t[0..i].sum);

  writeln(ans);
}
