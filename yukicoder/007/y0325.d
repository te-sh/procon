import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), x1 = rd[0], y1 = rd[1], x2 = rd[2], y2 = rd[3], d = rd[4];

  auto r = 0L;

  if (x2 >= 0 && y2 >= 0)
    r += calc(max(0, x1), max(0, y1), x2, y2, d);
  if (x1 <= 0 && y2 >= 0)
    r += calc(max(0, -x2), max(0, y1), -x1, y2, d);
  if (x1 <= 0 && y1 <= 0)
    r += calc(max(0, -x2), max(0, -y2), -x1, -y1, d);
  if (x2 >= 0 && y1 <= 0)
    r += calc(max(0, x1), max(0, -y2), x2, -y1, d);

  if (x1 <= 0 && x2 >= 0)
    r -= min(y2, d) - max(y1, -d) + 1;
  if (y1 <= 0 && y2 >= 0)
    r -= min(x2, d) - max(x1, -d) + 1;

  if (x1 <= 0 && x2 >= 0 && y1 <= 0 && y2 >= 0)
    --r;

  writeln(r);
}

auto calc(long x1, long y1, long x2, long y2, long d)
{
  if (x1 + y1 > d) return 0;
  if (x2 + y2 <= d) return (x2 - x1 + 1) * (y2 - y1 + 1);
  if (x2 == 0 && y2 == 0) return 1;
  if (x2 == 0) return min(y2, d) - y1 + 1;
  if (y2 == 0) return min(x2, d) - x1 + 1;

  auto r = 0L;

  if (x1 + y2 > d) {
    y2 = d - x1;
  } else if (x1 + y2 < d) {
    r += (d - y2 - x1) * (y2 - y1 + 1);
    x1 = d - y2;
  }

  if (x2 + y1 > d) {
    x2 = d - y1;
  } else if (x2 + y1 < d) {
    r += (d - x2 - y1) * (x2 - x1 + 1);
    y1 = d - x2;
  }

  r += (x2 - x1 + 1) * (x2 - x1 + 2) / 2;
  return r;
}
