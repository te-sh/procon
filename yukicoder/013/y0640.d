import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  auto s = readArrayM!string(n);

  auto r1 = calc(n, s);
  auto r2 = calc(n, s.transposed.map!(si => si.array.to!string).array);

  writeln(max(r1, r2));
}

auto calc(int n, string[] s)
{
  auto h = new int[][](n, n), v = new int[][](n, n);
  foreach (i; 0..n)
    foreach (j; 0..n) {
      h[i][j] = s[i][j] == '#';
      v[i][j] = s[j][i] == '#';
    }

  auto hc = new CumulativeSum!int*[](n), vc = new CumulativeSum!int*[](n);
  foreach (i; 0..n) {
    hc[i] = new CumulativeSum!int(h[i]);
    vc[i] = new CumulativeSum!int(v[i]);
  }

  auto rvh1 = 0;
  if (!(*vc[0])[0..n-1]) {
    ++rvh1;
    foreach (i; 0..n-1) rvh1 += !(*hc[i])[1..n];
    rvh1 += !(*hc[n-1])[0..n-1] || !(*hc[n-1])[1..n];
  }

  auto rvh2 = 0;
  if (!(*vc[0])[1..n]) {
    ++rvh2;
    rvh2 += !(*hc[0])[0..n-1] || !(*hc[0])[1..n];
    foreach (i; 1..n) rvh2 += !(*hc[i])[1..n];
  }

  auto rvh3 = 0;
  if (!(*vc[n-1])[0..n-1]) {
    ++rvh3;
    foreach (i; 0..n-1) rvh3 += !(*hc[i])[0..n-1];
    rvh3 += !(*hc[n-1])[0..n-1] || !(*hc[n-1])[1..n];
  }

  auto rvh4 = 0;
  if (!(*vc[n-1])[1..n]) {
    ++rvh4;
    rvh4 += !(*hc[0])[0..n-1] || !(*hc[0])[1..n];
    foreach (i; 1..n) rvh4 += !(*hc[i])[0..n-1];
  }

  auto rh = 0;
  foreach (i; 0..n)
    rh += !(*hc[i])[0..n-1] || !(*hc[i])[1..n];

  auto ro = 0;
  if (!(*hc[0])[0..n] && !(*hc[n-1])[0..n] && !(*vc[0])[0..n] && !(*vc[n-1])[0..n])
    ro += 4;

  return max(rvh1, rvh2, rvh3, rvh4, rh, ro);
}

struct CumulativeSum(T)
{
  size_t n;
  T[] s;

  this(T[] a)
  {
    n = a.length;
    s = new T[](n+1);
    s[0] = T(0);
    foreach (i; 0..n) s[i+1] = s[i] + a[i];
  }

  T opSlice(size_t l, size_t r) { return s[r]-s[l]; }
  size_t opDollar() { return n; }
}
