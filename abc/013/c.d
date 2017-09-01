import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(long[]), n = rd1[0], h = rd1[1];
  auto rd2 = readln.split.to!(long[]), a = rd2[0], b = rd2[1], c = rd2[2], d = rd2[3], e = rd2[4];

  auto r = long.max;
  foreach (x; 0..n+1) {
    auto y = (e * n - h - (b + e) * x + d + e) / (d + e);
    if (y < 0) y = 0;
    r = min(r, a * x + c * y);
  }

  writeln(r);
}
