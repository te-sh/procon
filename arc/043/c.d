import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto a = readln.split.to!(int[]);
  auto b = readln.split.to!(int[]);

  auto c = new int[](n+1);
  foreach (int i, ai; a) c[ai] = i+1;
  foreach (ref bi; b) bi = c[bi];

  auto bt = BiTree!int(n), t = 0L;
  foreach_reverse (bi; b) {
    t += bt[1..bi];
    bt[bi] += 1;
  }

  if (t % 2) {
    writeln(-1);
    return;
  }

  t /= 2;

  int[] r;
  auto v = new bool[](n+1);
  foreach (bi; b) {
    auto s = bt[0..bi];
    v[bi] = true;
    if (t > s) {
      r ~= bi;
      t -= s;
      bt[bi] += -1;
    } else {
      auto i = 1, u = 0;
      for (; i < bi && u < s-t; ++i)
        if (!v[i]) {
          r ~= i;
          ++u;
        }
      r ~= bi;
      for (; i <= n; ++i)
        if (!v[i])
          r ~= i;
      break;
    }
  }

  foreach (i, ri; r) {
    write(a[ri-1]);
    if (i < n-1) write(" ");
  }
  writeln;
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
