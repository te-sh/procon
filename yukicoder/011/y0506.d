import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

const mod = 10^^9+7;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1], k = rd[2], p = rd[3];

  struct Friend { int x, y; string name; }
  auto f = new Friend[](k);
  foreach (i; 0..k) {
    auto rd2 = readln.split;
    f[i] = Friend(rd2[0].to!int, rd2[1].to!int, rd2[2]);
  }

  auto maxR = 0L, maxI = 0;
  foreach (i; 0..1<<k) {
    if (i.popcnt != p) continue;
    auto fm = new bool[][](h+1, w+1);
    foreach (j; 0..k)
      if (!i.bitTest(j)) fm[f[j].x][f[j].y] = true;

    auto rm = new long[][](h+1, w+1);
    rm[0][0] = 1;
    foreach (x; 0..h+1)
      foreach (y; 0..w+1) {
        if (fm[x][y]) continue;
        if (x > 0) rm[x][y] += rm[x-1][y];
        if (y > 0) rm[x][y] += rm[x][y-1];
      }

    if (rm[h][w] > maxR) {
      maxR = rm[h][w];
      maxI = i;
    }
  }

  writeln(maxR % mod);
  foreach (j; 0..k)
    if (maxI.bitTest(j))
      writeln(f[j].name);
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }

  pure T bitSet(T)(T n, size_t s, size_t e) { return n | ((T(1) << e) - 1) & ~((T(1) << s) - 1); }
  pure T bitReset(T)(T n, size_t s, size_t e) { return n & (~((T(1) << e) - 1) | ((T(1) << s) - 1)); }
  pure T bitComp(T)(T n, size_t s, size_t e) { return n ^ ((T(1) << e) - 1) & ~((T(1) << s) - 1); }

  import core.bitop;
  pure int bsf(T)(T n) { return core.bitop.bsf(ulong(n)); }
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
  pure int popcnt(T)(T n) { return core.bitop.popcnt(ulong(n)); }
}
