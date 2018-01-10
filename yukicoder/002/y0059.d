import std.algorithm, std.conv, std.range, std.stdio, std.string;

T read1(T)(){return readln.chomp.to!T;}
void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}
const auto maxW = 1_000_000;

version(unittest) {} else
void main()
{
  int n, k; read2(n, k);

  auto bt = BiTree!int(maxW+1);
  foreach (_; 0..n) {
    auto w = read1!int;
    if (w > 0) {
      if (bt[w..$] < k)
        ++bt[w];
    } else {
      w = -w;
      if (bt[w] > 0)
        --bt[w];
    }
  }

  writeln(bt[0..$]);
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
