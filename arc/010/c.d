import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1], y = rd1[2], z = rd1[3];

  int[char] col;
  auto p = new int[](m);

  foreach (i; 0..m) {
    auto rd2 = readln.split, c = rd2[0][0], pi = rd2[1].to!int;
    col[c] = i;
    p[i] = pi;
  }

  auto b = readln.chomp.map!(bi => col[cast(char)bi]);
  auto inf = 10L ^^ 16;

  auto dp1 = new long[][](m, 1<<m), dp2 = new long[][](m, 1<<m);
  foreach (i; 0..m) dp1[i][1..$] = -inf;

  foreach (bi; b) {
    foreach (i; 0..m)
      dp2[i][] = dp1[i][];

    foreach (i; 0..m)
      foreach (j; 0..1<<m) {
        auto nj = j.bitSet(bi);
        dp1[bi][nj] = max(dp1[bi][nj], dp2[i][j] + p[bi] + (j && (bi == i) ? y : 0));
      }
  }

  foreach (i; 0..m) dp1[i][$-1] += z;

  auto ans = -inf;
  foreach (i; 0..m)
    foreach (j; 0..1<<m)
      ans = max(ans, dp1[i][j]);

  writeln(ans);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
