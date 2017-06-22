import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], m = rd[1];

  auto fibs = new long[](n);
  fibs[0] = fibs[1] = 1;
  foreach (i; 2..n)
    fibs[i] = fibs[i-1] + fibs[i-2];

  auto d = fibs[n-1] - m;

  if (d < 0) {
    writeln(-1);
    return;
  }
  fibs = fibs[0..$-2];

  auto r = 0;
  while (d > 0) {
    auto s = fibs.assumeSorted!"a <= b".lowerBound(d);
    d -= s.back;
    ++r;
    fibs = s.array[0..$-1];
  }

  writeln(r);
}
