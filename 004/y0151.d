import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], q = rd[1];

  auto pondL = BiTree!long(n + q + 2);
  auto pondR = BiTree!long(n + q + 2);

  foreach (t; 0..q) {
    auto pl(size_t i) { return i + t + 2; }
    auto pr(size_t i) { return i - t + q + 1; }

    auto rd2 = readln.split;
    switch (rd2[0]) {
    case "L":
      auto y = rd2[1].to!size_t, z = rd2[2].to!long;
      pondL.add(pl(y), z);
      break;
    case "R":
      auto y = rd2[1].to!size_t, z = rd2[2].to!long;
      pondR.add(pr(y), z);
      break;
    case "C":
      auto y = rd2[1].to!size_t, z = rd2[2].to!size_t;
      auto nl = pondL.get(pl(z-1)) - pondL.get(pl(y-1));
      auto nr = pondR.get(pr(z-1)) - pondR.get(pr(y-1));
      writeln(nl + nr);
      break;
    default:
      assert(0);
    }

    auto vl = pondL.get(pl(0)) - pondL.get(pl(-1));
    auto vr = pondR.get(pr(n-1)) - pondR.get(pr(n-2));
    if (vl) {
      pondL.add(pl(0), -vl); pondR.add(pr(-1), vl);
    }
    if (vr) {
      pondR.add(pr(n-1), -vr); pondL.add(pl(n), vr);
    }
  }
}

struct BiTree(T)
{
  T[] b; // buffer
  const size_t s; // size

  this(size_t t)
  {
    s = t;
    b = new T[](s + 1);
  }

  pure T get(size_t i) const
  {
    return i ? b[i] + get(i - (i & -i)) : 0;
  }

  void add(size_t i, T v)
  {
    if (i > s) return;
    b[i] += v;
    add(i + (i & -i), v);
  }
}
