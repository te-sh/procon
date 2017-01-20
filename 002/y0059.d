import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto maxW = 1_000_000;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, k = rd[1].to!int;

  auto bt = new BiTree!int(maxW);
  foreach (_; n.iota) {
    auto w = readln.chomp.to!int;
    if (w > 0) {
      if (bt.get(maxW) - bt.get(w - 1) < k)
        bt.add(w, 1);
    } else {
      w = -w;
      if (bt.get(w) - bt.get(w - 1) > 0)
        bt.add(w, -1);
    }
  }

  writeln(bt.get(maxW));
}

class BiTree(T) {
  T[] b; // buffer
  size_t s; // size

  this(size_t t) {
    s = t;
    b = new int[](s + 1);
  }

  int get(size_t i) {
    if (!i) return 0;
    return b[i] + get(i - (i & -i));
  }

  void add(size_t i, T v) {
    if (i > s) return;
    b[i] += v;
    add(i + (i & -i), v);
  }
}
