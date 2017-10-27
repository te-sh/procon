import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp, n = s.length;
  auto sa = SuffixArray(s);
  auto saa = new string[](n);
  foreach (i; 0..n) saa[i] = sa[i];
  auto sas = saa.assumeSorted;

  auto m = readln.chomp.to!size_t, ans = size_t(0);
  foreach (_; 0..m) {
    auto c = readln.chomp;
    auto r1 = sas.lowerBound(c);
    auto r2 = sas.upperBound(c ~ "|");
    ans += n - r1.length - r2.length;
  }

  writeln(ans);
}

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
