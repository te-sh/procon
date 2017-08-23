import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto a = 0, b = 0;

  foreach (_; n.iota) {
    auto rd = readln.split, t = rd[0].to!int, s = rd[1].length;
    auto c = min(12 * t / 1000, s);
    a += c;
    b += s - c;
  }

  writeln(a, " ", b);
}
