import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  auto rbt = redBlackTree!(true, long)();
  int q, k; readV(q, k);
  auto v = new long[](q);
  foreach (i; 0..q) {
    auto rd = readln.splitter;
    auto t = rd.front.to!int; rd.popFront();
    switch (t) {
    case 1:
      v[i] = rd.front.to!long;
      break;
    case 2:
      v[i] = -1;
      break;
    default:
      assert(0);
    }
  }

  auto u = v.dup.sort.uniq.array, n = u.length.to!int;
  int[long] buf;
  foreach (int i, ui; u) buf[ui] = i;

  auto bt = BiTree!int(n);
  foreach (vi; v) {
    if (vi != -1) {
      ++bt[buf[vi]];
    } else {
      if (bt[0..$] < k) {
        writeln(-1);
      } else {
        auto bs = iota(0, n).map!(x => tuple(x, bt[0..x])).assumeSorted!"a[1] < b[1]";
        auto r = bs.lowerBound(tuple(0, k)).back[0];
        writeln(u[r]);
        --bt[r];
      }
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
