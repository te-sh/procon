import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto sumA = ai.sum;
  auto r = int.max;
  for (auto p = 1; (p + 1) ^^ 2 / 4 <= sumA; p += 2) {
    auto s = 0;
    foreach (i, a; ai) {
      if (i >= p) {
        s += a;
      } else {
        auto b = i < (p + 1) / 2 ? i + 1 : p - i;
        if (a > b) s += a - b;
      }
    }
    r = min(r, s);
  }

  writeln(r);
}
