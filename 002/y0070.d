import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto r = 0;
  foreach (_; n.iota) {
    auto rd = readln.split, a = toMin(rd[0]), b = toMin(rd[1]);
    auto c = b - a;
    if (c < 0) c += 24 * 60;
    r += c;
  }

  writeln(r);
}

auto toMin(string a)
{
  auto hm = a.split(":"), h = hm[0].to!int, m = hm[1].to!int;
  return h * 60 + m;
}
