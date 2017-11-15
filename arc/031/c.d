import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto b = readln.split.map!(to!int).map!"a-1".array;

  auto ld = new int[](n), bt1 = BiTree!int(n);
  foreach (bi; b) {
    ld[bi] = bt1[bi..$];
    bt1[bi] += 1;
  }

  auto rd = new int[](n), bt2 = BiTree!int(n);
  foreach_reverse (bi; b) {
    rd[bi] = bt2[bi..$];
    bt2[bi] += 1;
  }

  auto ans = 0L;
  foreach (i; 0..n)
    ans += min(ld[i], rd[i]);

  writeln(ans);
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
