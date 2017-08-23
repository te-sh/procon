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

unittest
{
  import std.algorithm;

  auto a = [1, 5, 9, 2, 4, 1, 3];

  auto st1 = SparseTable!int(a);
  assert(st1[0..1] == 1);
  assert(st1[0..3] == 1);
  assert(st1[1..4] == 2);
  assert(st1[4..$] == 1);

  auto st2 = SparseTable!(int, max)(a);
  assert(st2[0..1] == 1);
  assert(st2[0..3] == 9);
  assert(st2[1..4] == 9);
  assert(st2[4..$] == 4);
}
