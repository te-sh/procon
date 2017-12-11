import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = readln.split.to!(int[]);
  auto b = readln.split.to!(int[]);

  auto c = new int[](n+1);
  foreach (int i, ai; a) c[ai] = i;

  foreach (ref bi; b) bi = c[bi];

  auto bt = BiTree!int(n);
  int[] r;

  foreach (bi; b) {
    if (bt[bi..$] == 0) r ~= bi;
    bt[bi] += 1;
  }

  foreach (ref ri; r) ri = a[ri];

  r.sort();

  foreach (ri; r) writeln(ri);
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

  void opIndexOpAssign(string op: "+")(T val, size_t i)
  {
    ++i;
    for (; i <= n; i += i & -i)
      buf[i] += val;
  }

  pure T opSlice(size_t r, size_t l) const
  {
    return get(l) - get(r);
  }

  pure size_t opDollar() const { return n; }
  pure T opIndex(size_t i) const { return opSlice(i, i+1); }

private:

  pure T get(size_t i) const
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i)
      s += buf[i];
    return s;
  }
}
