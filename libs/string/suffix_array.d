struct SuffixArray
{
  import std.algorithm;

  string s;
  size_t n;
  size_t[] x;

  this(string s)
  {
    this.s = s;
    n = s.length;
    x = new size_t[](n);
    auto r = new size_t[](n), t = new size_t[](n);

    foreach (i; 0..n) r[x[i] = i] = s[i];
    for (size_t h = 1; t[n-1] != n-1; h <<= 1) {
      auto cmp(size_t i, size_t j)
      {
        if (r[i] != r[j]) return r[i] < r[j];
        return i+h < n && j+h < n ? r[i+h] < r[j+h] : i > j;
      }
      x.sort!((a, b) => cmp(a, b));
      foreach (i; 0..n-1) t[i+1] = t[i] + cmp(x[i], x[i+1]);
      foreach (i; 0..n) r[x[i]] = t[i];
    }
  }

  auto opIndex(size_t i) { return s[x[i]..$]; }
}

unittest
{
  auto s = "aeadacab";
  auto sa = SuffixArray(s);

  assert(sa[0] == "ab");
  assert(sa[1] == "acab");
  assert(sa[2] == "adacab");
  assert(sa[3] == "aeadacab");
  assert(sa[4] == "b");
  assert(sa[5] == "cab");
  assert(sa[6] == "dacab");
  assert(sa[7] == "eadacab");
}
