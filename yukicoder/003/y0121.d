import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto bi = ai.dup.sort().array.uniq.array;
  int[int] ci;
  foreach (int i, b; bi) ci[b] = i + 1;

  auto di = ai.map!(a => ci[a]).array;
  auto maxD = di.maxElement;

  auto bt1 = BiTree!long(maxD + 1);
  bt1[di[0]] += 1;

  auto bt2 = BiTree!long(maxD + 1);
  foreach (d; di[2..$]) bt2[d] += 1;

  auto ne = bt2[di[0]];
  auto r = 0L;

  foreach (i; 1..n-1) {
    auto d1 = di[i], d2 = di[i+1];

    r += bt1[0..d1] * bt2[0..d1];
    r += bt1[d1+1..$] * bt2[d1+1..$];
    r -= ne - bt1[d1] * bt2[d1];

    bt1[d1] += 1;
    ne += bt2[d1];
    bt2[d2] += -1;
    ne -= bt1[d2];
  }

  writeln(r);
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
