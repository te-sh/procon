import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], d = rd[1], k = rd[2];
  auto x = new int[](n);
  foreach (i; 0..n) x[i] = readln.chomp.to!int;

  auto st = SparseTable!(int, max)(x);
  auto ri = 0, rp = 0, rs = 0;
  foreach (i; 0..n-1) {
    auto p = st[i+1..min(i+1+d,n)], s = p-x[i];
    if (s > rs) {
      ri = i;
      rp = p;
      rs = s;
    }
  }

  if (rs == 0) {
    writeln(0);
    return;
  }

  writeln(k.to!long * rs);
  write(ri, " ");
  foreach (i; ri+1..n)
    if (x[i] == rp) {
      writeln(i);
      break;
    }
}

struct SparseTable(T, alias pred = "a < b ? a : b")
{
  import std.algorithm, std.functional;
  alias predFun = binaryFun!pred;

  size_t[] logTable;
  size_t[][] rmq;
  size_t n;
  T[] a;

  this(T[] a)
  {
    this.a = a;
    this.n = a.length;

    logTable = new size_t[n + 1];
    foreach (i; 2..n+1)
      logTable[i] = logTable[i >> 1] + 1;

    rmq = new size_t[][](logTable[n] + 1, n);

    foreach (i; 0..n)
      rmq[0][i] = i;

    for (size_t k = 1; (1 << k) < n; ++k)
      for (size_t i = 0; i + (1 << k) <= n; ++i) {
        auto x = rmq[k - 1][i];
        auto y = rmq[k - 1][i + (1 << k - 1)];
        rmq[k][i] = predFun(a[x], a[y]) == a[x] ? x : y;
      }
  }

  pure size_t opDollar() const { return n; }

  pure T opSlice(size_t l, size_t r) const
  {
    auto k = logTable[r - l - 1];
    auto x = rmq[k][l];
    auto y = rmq[k][r - (1 << k)];
    return predFun(a[x], a[y]);
  }
}
