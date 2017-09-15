import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!int, k = rd[1].to!size_t;
  auto d = readln.split.to!(int[]);
  auto db = new bool[](10);
  foreach (di; d) db[di] = true;

  while (toDigits(n).any!(i => db[i])) ++n;
  writeln(n);
}

auto toDigits(int n)
{
  int[] r;
  for (; n > 0; n /= 10) r ~= n % 10;
  return r;
}
