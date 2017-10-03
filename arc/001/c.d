import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  const n = 8;

  struct Status
  {
    int y, x, s, t;
    ulong b;

    auto invalid() { return y == -1; }

    auto emptyI()
    {
      foreach (i; 0..n)
        if (!y.bitTest(i)) return i;
      return -1;
    }

    auto conflict(int i, int j)
    {
      return y.bitTest(i) || x.bitTest(j) || s.bitTest(i+j) || t.bitTest(i-j+n-1);
    }

    auto set(int i, int j)
    {
      return Status(y.bitSet(i), x.bitSet(j), s.bitSet(i+j), t.bitSet(i-j+n-1), b.bitSet(i*n+j));
    }
  }

  auto invalid = Status(-1, -1, -1, -1, 0);
  Status s;

  foreach (i; 0..n) {
    auto rd = readln.chomp;
    foreach (int j, c; rd)
      if (c == 'Q') {
        if (s.conflict(i, j)) {
          writeln("No Answer");
          return;
        }
        s = s.set(i, j);
      }
  }

  Status calc(Status s)
  {
    auto i = s.emptyI;
    if (i == -1) return s;

    foreach (j; 0..n) {
      if (!s.conflict(i, j)) {
        auto r = calc(s.set(i, j));
        if (!r.invalid) return r;
      }
    }

    return invalid;
  }

  auto r = calc(s);
  if (r.invalid) {
    writeln("No Answer");
    return;
  }

  foreach (i; 0..n) {
    foreach (j; 0..n)
      write(r.b.bitTest(i*n+j) ? "Q" : ".");
    writeln;
  }
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }
  pure T bitSet(T)(T n, size_t i) { return n | (T(1) << i); }
  pure T bitReset(T)(T n, size_t i) { return n & ~(T(1) << i); }
  pure T bitComp(T)(T n, size_t i) { return n ^ (T(1) << i); }
}
