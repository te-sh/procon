import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags

void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}

version(unittest) {} else
void main()
{
  int n, k; read2(n, k);

  auto f = new long[](n+1);
  f[n] = 1;

  foreach_reverse (i; 1..n+1) {
    f[i-1] = f[i] % k * i;
    f[i] /= k;
  }

  --f[1];
  foreach (i; 1..n) {
    if (f[i] < 0) {
      f[i] = i;
      --f[i+1];
    }
  }

  auto bt = BiTree!int(n+1);
  foreach (i; 1..n+1) ++bt[i];
  auto bs = iota(1, n+1).map!(x => tuple(x, bt[0..x])).assumeSorted!"a[1] < b[1]";

  foreach_reverse(i; 0..n) {
    auto r = bs.equalRange(tuple(0, f[i])).back;
    writeln(r[0]);
    --bt[r[0]];
  }
}

struct BiTree(T)
{
  const size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n+1);
  }

  void opIndexOpAssign(string op)(T val, size_t i) if (op == "+" || op == "-")
  {
    ++i;
    for (; i <= n; i += i & -i) mixin("buf[i] " ~ op ~ "= val;");
  }

  void opIndexUnary(string op)(size_t i) if (op == "++" || op == "--")
  {
    ++i;
    for (; i <= n; i += i & -i) mixin("buf[i]" ~ op ~ ";");
  }

  pure T opSlice(size_t r, size_t l) { return get(l) - get(r); }
  pure T opIndex(size_t i) { return opSlice(i, i+1); }
  pure size_t opDollar() { return n; }

private:

  pure T get(size_t i)
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i) s += buf[i];
    return s;
  }
}
