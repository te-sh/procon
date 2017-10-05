import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto c = new int[](n);
  foreach (i; 0..n) c[i] = i.to!int+1;

  auto curr = 0;
  foreach (_; 0..m) {
    auto d = readln.chomp.to!int;
    if (d == curr) continue;
    auto i = c.countUntil(d);
    swap(curr, c[i]);
  }

  foreach (ci; c) writeln(ci);
}
