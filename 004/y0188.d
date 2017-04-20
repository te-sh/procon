import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.datetime;

version(unittest) {} else
void main()
{
  auto s = Date(2015, 1, 1);
  auto e = Date(2015, 12, 31);

  auto c = 0;
  for (auto d = s; d <= e; d+= days(1)) {
    if (d.month == sumDigits(d.day)) ++c;
  }

  writeln(c);
}

auto sumDigits(int n)
{
  auto r = 0;
  for (; n > 0; n /= 10) r += n % 10;
  return r;
}
