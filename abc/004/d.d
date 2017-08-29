import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), r = rd[0], g = rd[1], b = rd[2];

  auto mi = min(-g+1, 100-b-g+1);
  auto ma = max(g-1, -100+r+g-1)-g+1;

  auto t = int.max;

  foreach (x; mi..ma+1) {
    auto ti = moveTimes(x, x+g-1, 0);

    if (x > -100+(r-1)/2)
      ti += moveTimes(-100-r/2, -100+(r-1)/2, -100);
    else
      ti += moveTimes(x-r, x-1, -100);

    if (x+g-1 < 100-(b-1)/2)
      ti += moveTimes(100-(b-1)/2, 100+b/2, 100);
    else
      ti += moveTimes(x+g, x+g+b-1, 100);

    t = min(t, ti);
  }

  writeln(t);
}

auto moveTimes(int x, int y, int offset)
{
  x -= offset; y -= offset;
  auto z = y - x + 1;

  if (y < 0)
    return -y * z + z * (z-1) / 2;
  else if (x > 0)
    return x * z + z * (z-1) / 2;
  else
    return -x * (-x + 1) / 2 + y * (y + 1) / 2;
}
