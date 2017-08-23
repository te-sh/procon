import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  auto n = rd[0].to!size_t, d = rd[1].to!long, t = rd[2].to!long;
  auto xi = readln.split.map!(to!long);

  long[][long] xmi;
  foreach (x; xi) xmi[mod(x, d)] ~= x;

  auto r = 0L;
  foreach (m, yi; xmi) {
    r += calc(yi.map!(y => div(y, d)).array, t);
  }

  writeln(r);
}

long calc(long[] yi, long t)
{
  yi.sort();

  auto r = 2 * t + 1;
  auto e = yi[0] + t;

  foreach (y; yi[1..$]) {
    r += 2 * t + 1;
    if (e >= y - t)
      r -= e - (y - t) + 1;
    e = y + t;
  }

  return r;
}

long div(long a, long b)
{
  return a / b - (a >= 0 ? 0 : 1);
}

long mod(long a, long b)
{
  return a % b + (a >= 0 ? 0 : b);
}
