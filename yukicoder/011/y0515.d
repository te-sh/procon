import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  auto s = readArrayM!string(n);
  long m, x, d; readV(m, x, d);

  struct SS { string s; int i; }
  auto ss = new SS[](n);
  foreach (i; 0..n) ss[i] = SS(s[i], i+1);
  ss.sort!"a.s < b.s";

  auto cv = new int[](n+1);
  foreach (i; 0..n) cv[ss[i].i] = i;

  auto t = new int[](n-1);
  foreach (i; 0..n-1) t[i] = lcp(ss[i].s, ss[i+1].s);

  auto st = SparseTable!int(t), ans = 0L;

  foreach (k; 1..m+1) {
    auto i = (x/(n-1))+1;
    auto j = (x%(n-1))+1;
    if (i > j) swap(i, j);
    else       ++j;
    x = (x+d)%(n.to!long*(n-1));

    auto i2 = cv[i], j2 = cv[j];
    if (i2 > j2) swap(i2, j2);

    ans += st[i2..j2];
  }

  writeln(ans);
}

auto lcp(string a, string b)
{
  auto n = min(a.length, b.length).to!int;
  foreach (i; 0..n)
    if (a[i] != b[i]) return i;
  return n;
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

    logTable = new size_t[n+1];
    foreach (i; 2..n+1)
      logTable[i] = logTable[i>>1]+1;

    rmq = new size_t[][](logTable[n]+1, n);

    foreach (i; 0..n) rmq[0][i] = i;

    for (size_t k = 1; (1<<k) < n; ++k)
      for (size_t i = 0; i+(1<<k) <= n; ++i) {
        auto x = rmq[k-1][i];
        auto y = rmq[k-1][i+(1<<k-1)];
        rmq[k][i] = predFun(a[x], a[y]) == a[x] ? x : y;
      }
  }

  pure T opSlice(size_t l, size_t r)
  {
    auto k = logTable[r-l-1];
    auto x = rmq[k][l];
    auto y = rmq[k][r-(1<<k)];
    return predFun(a[x], a[y]);
  }

  pure size_t opDollar() { return n; }
}
