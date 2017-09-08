import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto h = new long[](n), s = new long[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    h[i] = rd.front.to!long; rd.popFront();
    s[i] = rd.front.to!long;
  }

  auto maxX = 0L;
  foreach (i; 0..n) maxX = max(maxX, h[i] + s[i] * (n-1));

  auto ct = new int[](n);

  auto calc(long x)
  {
    ct[] = 0;

    foreach (i; 0..n) {
      if (x < h[i]) return false;
      auto t = (x - h[i]) / s[i];
      if (t < n) ++ct[t];
    }

    if (ct[0] > 1) return false;

    foreach (i; 1..n) {
      ct[i] += ct[i-1];
      if (ct[i] > i+1) return false;
    }

    return true;
  }

  struct xc { long x; bool c; }

  auto ans = iota(1, maxX+1)
    .map!(x => xc(x, calc(x)))
    .assumeSorted!"a.c < b.c"
    .equalRange(xc(0, true)).front.x;

  writeln(ans);
}
