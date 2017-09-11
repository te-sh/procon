import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto b = new int[][](2);
  foreach (i; 0..2) b[i] = readln.split.to!(int[]);
  auto c = new int[][](3);
  foreach (i; 0..3) c[i] = readln.split.to!(int[]);

  struct P { int p1, p2; }

  P[int] memo;

  P calc(int x, int y)
  {
    auto mi = ((x << 9) | y);
    if (mi in memo) return memo[mi];

    if (y == (1 << 9) - 1) {
      auto p = P(0, 0);
      foreach (i; 0..2)
        foreach (j; 0..3) {
          if (x.bitTest(i*3+j) == x.bitTest((i+1)*3+j)) p.p1 += b[i][j];
          else                                          p.p2 += b[i][j];
        }
      foreach (i; 0..3)
        foreach (j; 0..2) {
          if (x.bitTest(i*3+j) == x.bitTest(i*3+(j+1))) p.p1 += c[i][j];
          else                                          p.p2 += c[i][j];
        }

      return memo[mi] = p;
    }

    auto turn = y.popcnt % 2 == 0;
    auto maxP = P(-1, -1);

    foreach (i; 0..9) {
      if (y.bitTest(i)) continue;
      auto p = calc(turn ? x.bitSet(i) : x, y.bitSet(i));
      if (maxP.p1 == -1 || turn && (p.p1 - p.p2) > (maxP.p1 - maxP.p2) || !turn && (p.p2 - p.p1) > (maxP.p2 - maxP.p1)) maxP = p;
    }

    return memo[mi] = maxP;
  }

  auto p = calc(0, 0);
  writeln(p.p1);
  writeln(p.p2);
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
