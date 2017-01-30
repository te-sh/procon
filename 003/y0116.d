import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  writeln((n-2).iota.count!(i => ai.drop(i).take(3).isKadomatsu));
}

auto isKadomatsu(Range)(Range ai)
{
  auto a1 = ai[0], a2 = ai[1], a3 = ai[2];
  return (a1 != a2 && a2 != a3 && a3 != a1) &&
    (a2 < a1 && a1 < a3 || a3 < a1 && a1 < a2 || a2 < a3 && a3 < a1 || a1 < a3 && a3 < a2);
}
