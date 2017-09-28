import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc075_b

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, a = rd[1].to!long, b = rd[2].to!long, c = a-b;
  auto h = new long[](n);
  foreach (i; 0..n) h[i] = readln.chomp.to!long;

  auto calc(long x)
  {
    auto y = 0;
    foreach (hi; h) {
      auto g = hi - b * x;
      if (g > 0) {
        y += (g + c - 1) / c;
        if (y > x) return false;
      }
    }
    return true;
  }

  struct XR { long x; bool r; }

  auto ma = (h.reduce!max + b - 1) / b;
  auto r = iota(1L, ma+1)
    .map!(x => XR(x, calc(x)))
    .assumeSorted!"a.r < b.r"
    .equalRange(XR(0L, true))
    .front.x;

  writeln(r);
}
