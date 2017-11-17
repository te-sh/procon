import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto q = readln.chomp.to!int;

  auto m = 200000;
  auto bt = BiTree!int(200000);

  foreach (_; 0..q) {
    auto rd = readln.splitter;
    auto t = rd.front.to!int; rd.popFront();
    auto x = rd.front.to!int;

    if (t == 1) {
      bt[x] += 1;
    } else {
      auto bsearch = iota(1, m+1).map!(y => tuple(y, bt[0..y])).assumeSorted!"a[1] < b[1]";
      auto r = bsearch.equalRange(tuple(0, x-1)).back[0];
      writeln(r);
      bt[r] += -1;
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
