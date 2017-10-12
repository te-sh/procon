import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.datetime;

version(unittest) {} else
void main()
{
  auto y = 2012;
  auto n = readln.chomp.to!size_t;
  auto nh = new Date[](n);
  foreach (i; 0..n) {
    auto rd = readln.chomp.split('/').to!(int[]), m = rd[0], d = rd[1];
    nh[i] = Date(y, m, d);
  }
  auto nhs = nh.sort();

  auto h = new bool[](366), furi = 0;
  for (auto c = Date(2012, 1, 1); c.year == y; c += 1.days) {
    auto isNh = nhs.contains(c), dw = c.dayOfWeek, dy = c.dayOfYear-1;
    if (dw == DayOfWeek.sun || dw == DayOfWeek.sat) {
      h[dy] = true;
      if (isNh) ++furi;
    } else {
      if (isNh) {
        h[dy] = true;
      } else if (furi) {
        h[dy] = true;
        --furi;
      }
    }
  }

  auto r = new int[](366); r[0] = h[0];
  foreach (i; 1..366) r[i] = h[i] ? r[i-1] + 1 : 0;

  writeln(r.reduce!max);
}
