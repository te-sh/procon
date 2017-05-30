import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split;
  auto n = rd1[0].to!int, n2 = n * 2;
  auto q = rd1[1].to!size_t;

  auto bt = BiTree!long(n2);

  auto summary(int t, int y, int z)
  {
    auto r = 0L;

    auto yl = ((y - t) % n2 + n2) % n2;
    auto zl = ((z - t) % n2 + n2) % n2;
    if (yl < zl) {
      r += bt[yl..zl];
    } else {
      r += bt[yl..$];
      r += bt[0..zl];
    }

    auto yr = ((n2 - z - t) % n2 + n2) % n2;
    auto zr = ((n2 - 1 - y - t) % n2 + n2) % n2 + 1;
    if (yr < zr) {
      r += bt[yr..zr];
    } else {
      r += bt[yr..$];
      r += bt[0..zr];
    }

    return r;
  }

  foreach (_; 0..q) {
    auto rd2 = readln.split;
    auto x = rd2[0], t = rd2[1].to!int;

    switch (x) {
    case "C":
      auto y = rd2[2].to!int, z = rd2[3].to!int;
      writeln(summary(t, y, z));
      break;
    case "R":
      auto y = rd2[2].to!int, z = rd2[3].to!long;
      bt[((y - t) % n2 + n2) % n2] += z;
      break;
    case "L":
      auto y = rd2[2].to!int, z = rd2[3].to!long;
      bt[((n2 - 1 - y - t) % n2 + n2) % n2] += z;
      break;
    default:
      assert(0);
    }
  }
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
