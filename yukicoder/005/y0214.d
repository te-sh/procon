import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias FactorRing!(mod, true) mint;

const dpi = [2,3,5,7,11,13];
const dci = [4,6,8,9,10,12];

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!long, p = rd[1].to!int, c = rd[2].to!int;
  auto m = (dpi.maxElement * p + dci.maxElement * c).to!long;
  auto cpi = calcCombi!mint(dpi, p);
  auto cci = calcCombi!mint(dci, c);

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

T[] calcCombi(T)(const int[] di, int c)
{
  if (c == 0) return [];

  auto n = di.length.to!int, md = di.maxElement * c;
  auto dp = new T[][](c+1, md+1), dp2 = new T[][](c+1, md+1);
  dp[0][0] = T(1);

  foreach (d; di) {
    foreach (j; 0..c+1) {
      dp2[j][] = dp[j][];
      foreach (k; 1..j+1)
        foreach (i; k*d..md+1)
          dp[j][i] += dp2[j-k][i-k*d];
    }
  }

  return dp[c];
}

T kitamasa(T, U)(T[] a, T[] x, U k)
{
  import std.range;

  auto n = a.length;
  auto t = new T[](n*2+1);

  T[] rec(U k)
  {
    auto c = new T[](n);
    if (k < n) {
      c[k] = 1;
    } else {
      auto b = rec(k/2);
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

  auto r = T(0);
  foreach (i; 0..n) r += c[i] * x[i];

  return r;
}

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

  @property int toInt() { return vi; }
  alias toInt this;

  this(bool runMod = false)(int v)
  {
    static if (runMod) vi = mod(v);
    else vi = v;
  }

  ref FactorRing!(m, pos) opAssign(int v) { vi = v; return this; }

  pure auto mod(int v) const
  {
    static if (pos) return v % m;
    else return (v % m + m) % m;
  }

  pure auto mod(long v) const
  {
    static if (pos) return cast(int)(v % m);
    else return cast(int)((v % m + m) % m);
  }

  static if (m < int.max / 2) {
    pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!(m, pos)(mod(vi + rhs)); }
    pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!(m, pos)(mod(vi - rhs)); }
  } else {
    pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!(m, pos)(mod(vl + rhs)); }
    pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!(m, pos)(mod(vl - rhs)); }
  }
  pure auto opBinary(string op: "*")(int rhs) const { return FactorRing!(m, pos)(mod(vl * rhs)); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.vi); }

  static if (m < int.max / 2) {
    auto opOpAssign(string op: "+")(int rhs) { vi = mod(vi + rhs); }
    auto opOpAssign(string op: "-")(int rhs) { vi = mod(vi - rhs); }
  } else {
    auto opOpAssign(string op: "+")(int rhs) { vi = mod(vl + rhs); }
    auto opOpAssign(string op: "-")(int rhs) { vi = mod(vl - rhs); }
  }
  auto opOpAssign(string op: "*")(int rhs) { vi = mod(vl * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.vi); }
}
