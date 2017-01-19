import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.random;    // random

const auto iter = size_t(1_000_000);

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto k = readln.chomp.to!size_t;

  auto d1 = (size_t _) => uniform(1, 7);
  auto d2 = (size_t _) => uniform(4, 7);

  auto w = size_t(0);
  foreach (_; iter.iota) {
    auto taro = chain((n - k).iota.map!(d1), k.iota.map!(d2)).sum;
    auto jiro = n.iota.map!(d1).sum;

    if (taro > jiro) ++w;
  }

  writefln("%.5g", w.to!real / iter);
}
