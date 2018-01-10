import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bitmanip;  // BitArray

void read3(S,T,U)(ref S a,ref T b,ref U c){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;r.popFront;c=r.front.to!U;}
void read4(S,T,U,V)(ref S a,ref T b,ref U c,ref V d){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;r.popFront;c=r.front.to!U;r.popFront;d=r.front.to!V;r.popFront;}

const mod = 10^^9+7;

version(unittest) {} else
void main()
{
  int h, w, k, p; read4(h, w, k, p);

  struct Friend { int x, y; string name; }
  auto f = new Friend[](k);
  foreach (i; 0..k) {
    int x, y; string name; read3(x, y, name);
    f[i] = Friend(x, y, name);
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
