import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.random;    // random

const auto iter = 100_000;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t;
  auto pa = (rd[1].to!real * 1000).to!int, pb = (rd[2].to!real * 1000).to!int;
  auto ai = readln.split.to!(int[]);
  auto bi = readln.split.to!(int[]);

  ai.sort(); bi.sort();

  Random rnd;

  auto selectCard(ref int[] ci, int pc) {
    int c;
    if (ci.length == 1 || uniform(0, 1000, rnd) < pc) {
      c = ci.front;
      ci = ci.remove(0);
    } else {
      auto i = uniform(1, ci.length);
      c = ci[i];
      ci = ci.remove(i);
    }
    return c;
  }

  auto calc() {
    auto pta = 0, ptb = 0;
    auto ai2 = ai.dup, bi2 = bi.dup;

    while (!ai2.empty) {
      auto a = selectCard(ai2, pa);
      auto b = selectCard(bi2, pb);
      if (a > b) pta += a + b;
      else if (a < b) ptb += a + b;
    }

    return pta > ptb;
  }

  auto r = 0;
  foreach (_; iter.iota)
    if (calc) ++r;

  writefln("%.3f", r.to!real / iter);
}
