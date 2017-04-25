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

  auto bt1 = BiTree!long(maxD);
  bt1.add(di[0], 1);

  auto bt2 = BiTree!long(maxD);
  foreach (d; di[2..$]) bt2.add(d, 1);

  auto ne = bt2.get(di[0]) - bt2.get(di[0] - 1);
  auto r = 0L;

  foreach (i; 1..n-1) {
    auto d1 = di[i], d2 = di[i+1];

    r += bt1.get(d1-1) * bt2.get(d1-1);
    r += (bt1.get(maxD) - bt1.get(d1)) * (bt2.get(maxD) - bt2.get(d1));
    r -= ne - (bt1.get(d1) - bt1.get(d1-1)) * (bt2.get(d1) - bt2.get(d1-1));

    bt1.add(d1, 1);
    ne += bt2.get(d1) - bt2.get(d1-1);
    bt2.add(d2, -1);
    ne -= bt1.get(d2) - bt1.get(d2-1);
  }

  writeln(r);
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
