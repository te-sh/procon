import std.algorithm, std.conv, std.range, std.stdio, std.string;

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
      pondL[pl(y)] += z;
      break;
    case "R":
      auto y = rd2[1].to!size_t, z = rd2[2].to!long;
      pondR[pr(y)] += z;
      break;
    case "C":
      auto y = rd2[1].to!size_t, z = rd2[2].to!size_t;
      auto nl = pondL[pl(y)..pl(z)];
      auto nr = pondR[pr(y)..pr(z)];
      writeln(nl + nr);
      break;
    default:
      assert(0);
    }

    auto vl = pondL[pl(0)];
    auto vr = pondR[pr(n-1)];
    if (vl) {
      pondL[pl(0)] += -vl; pondR[pr(-1)] += vl;
    }
    if (vr) {
      pondR[pr(n-1)] += -vr; pondL[pl(n)] += vr;
    }
  }
}

struct BiTree(T)
{
  const size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n + 1);
  }

  void opIndexOpAssign(string op)(T val, size_t i)
    if (op == "+")
  {
    ++i;
    while (i <= n) {
      buf[i] += val;
      i += i & -i;
    }
  }

  pure size_t opDollar() { return n; }

  pure T opIndex(size_t i) const { return opSlice(i, i+1); }

  pure T opSlice(size_t r, size_t l) const
  {
    return get(l) - get(r);
  }

private:

  pure T get(size_t i) const
  {
    auto s = T(0);
    while (i > 0) {
      s += buf[i];
      i -= i & -i;
    }
    return s;
  }
}
