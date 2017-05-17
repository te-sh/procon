import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;
alias FactorRing!p mint;

const dpi = [2,3,5,7,11,13];
const dci = [4,6,8,9,10,12];

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!long, p = rd[1].to!int, c = rd[2].to!int;
  auto m = (dpi.maxElement * p + dci.maxElement * c).to!long;
  auto cpi = calcCombi(dpi, p);
  auto cci = calcCombi(dci, c);

  auto ci = new mint[](m+1);
  if (p == 0) {
    ci = cci;
  } else if (c == 0) {
    ci = cpi;
  } else {
    foreach (i, cp; cpi)
      foreach (j, cc; cci)
        ci[i+j] += cp * cc;
  }

  if (n <= m) {
    auto ai = new mint[](n+1);
    foreach (i; 1..n+1)
      foreach (j; 1..m+1)
        ai[i] += (i-j > 0 ? ai[i-j] : mint(1)) * ci[j];

    writeln(ai[n]);
  } else {
    auto ai = new mint[](m+1);
    foreach (i; 1..m+1)
      foreach (j; 1..m+1)
        ai[i] += (i-j > 0 ? ai[i-j] : mint(1)) * ci[j];

    auto di = ci.dup; di.reverse();

    auto r = kitamasa(di[0..$-1], ai[1..$], n-1);
    writeln(r);
  }
}

mint[] calcCombi(const int[] di, int c)
{
  auto n = di.length.to!int;
  if (c == 0)
    return [];

  auto ri = new int[][][](c);
  ri[0] = n.iota.map!(i => [i.to!int]).array;
  foreach (i; 1..c)
    ri[i] = ri[i-1].map!(r => iota(r.back, n).map!(d => r ~ d)).joiner.array;

  auto ci = new mint[](di.maxElement * c + 1);
  foreach (r; ri[$-1])
    ci[di.indexed(r).sum] += 1;

  return ci;
}

T kitamasa(T, U)(T[] a, T[] x, U k)
{
  import std.range;

  auto n = a.length;
  auto t = new T[](n * 2 + 1);

  T[] rec(U k)
  {
    auto c = new T[](n);
    if (k < n) {
      c[k] = T(1);
    } else {
      auto b = rec(k / 2);
      t[] = T(0);
      foreach (i; 0..n)
        foreach (j; 0..n)
          t[i+j+(k&1)] += b[i] * b[j];
      foreach_reverse (i; n..n*2)
        foreach (j; 0..n)
          t[i-n+j] += a[j] * t[i];
      c[] = t[0..n][];
    }
    return c;
  }

  auto c = rec(k);

  T r;
  foreach (ci, xi; lockstep(c, x)) r += ci * xi;

  return r;
}

struct FactorRing(int m)
{
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!m opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const { return _v > 0 ? _v % m : ((_v % m) + m) % m; }

  pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!m(v + rhs); }
  pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!m(v - rhs); }
  pure auto opBinary(string op: "*")(int rhs) const { return FactorRing!m(v * rhs); }

  pure auto opBinary(string op)(FactorRing!m rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.v); }

  auto opOpAssign(string op: "+")(int rhs) { v = mod(v + rhs); }
  auto opOpAssign(string op: "-")(int rhs) { v = mod(v - rhs); }
  auto opOpAssign(string op: "*")(int rhs) { v = mod(v * rhs); }

  auto opOpAssign(string op)(FactorRing!m rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.v); }
}
