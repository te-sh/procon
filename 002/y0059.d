import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto maxW = 1_000_000;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, k = rd[1].to!int;

  auto bt = BiTree!int(maxW + 1);
  foreach (_; n.iota) {
    auto w = readln.chomp.to!int;
    if (w > 0) {
      if (bt[w..$] < k)
        bt[w] += 1;
    } else {
      w = -w;
      if (bt[w] > 0)
        bt[w] += -1;
    }
  }

  writeln(bt[0..$]);
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
