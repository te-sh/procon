import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(long[]);
  auto ax = rd1[0], ay = rd1[1], bx = rd1[2], by = rd1[3];
  auto n = readln.chomp.to!size_t;
  auto x = new long[](n), y = new long[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split.to!(long[]);
    x[i] = rd2[0];
    y[i] = rd2[1];
  }

  auto r = 0;
  foreach (i; 0..n-1)
    if (isCross(ax, ay, bx, by, x[i], y[i], x[i+1], y[i+1])) ++r;
  if (isCross(ax, ay, bx, by, x[$-1], y[$-1], x[0], y[0])) ++r;

  writeln(r/2+1);
}

auto isCross(long ax, long ay, long bx, long by, long cx, long cy, long dx, long dy)
{
  return (((cx-dx) * (ay-cy) + (cy-dy) * (cx-ax)) * ((cx-dx) * (by-cy) + (cy-dy) * (cx-bx)) < 0 &&
          ((ax-bx) * (cy-ay) + (ay-by) * (ax-cx)) * ((ax-bx) * (dy-ay) + (ay-by) * (ax-dx)) < 0);
}
