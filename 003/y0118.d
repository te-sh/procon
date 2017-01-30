import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto p = 10L ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(long[]);

  long[long] cnt;
  foreach (a; ai) ++cnt[a];

  auto nl = n.to!long;
  auto r = nl * (nl - 1) * (nl - 2) / 6;

  foreach (c; cnt.byValue) {
    if (c >= 2)
      r -= c * (c - 1) / 2 * (nl - c);
    if (c >= 3)
      r -= c * (c - 1) * (c - 2) / 6;
  }

  writeln(r % p);
}
