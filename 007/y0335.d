import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), n = rd[0], m = rd[1];
  auto e = m.iota.map!(_ => readln.split.to!(int[])).array;

  writeln(e.map!(ei => calcE(n, ei)).maxIndex);
}

auto calcE(size_t n, int[] e)
{
  auto minSt = SparseTable!(int, min)(e);
  auto maxSt = SparseTable!(int, max)(e);
  auto s = 0L;

  foreach (i; 0..n-1)
    foreach (j; i+1..n) {
      auto ei = e[i], ej = e[j];

      if (ei < ej) {
        auto r1 = i > 0 && maxSt[0..i] > ei ? max(maxSt[0..i], ej) : 0;
        auto r2 = j > i+1 && maxSt[i+1..j] > ej ? maxSt[i+1..j] : j > i+1 && minSt[i+1..j] < ei ? ej : 0;
        auto r3 = j < n-1 && minSt[j+1..$] < ej ? ej : 0;
        s += max(r1, r2, r3);
      } else {
        auto r1 = i > 0 && minSt[0..i] < ei ? ei : 0;
        auto r2 = j > i+1 && maxSt[i+1..j] > ei ? maxSt[i+1..j] : j > i+1 && minSt[i+1..j] < ej ? ei : 0;
        auto r3 = j < n-1 && maxSt[j+1..$] > ej ? max(maxSt[j+1..$], ei) : 0;
        s += max(r1, r2, r3);
      }
    }

  return s;
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
