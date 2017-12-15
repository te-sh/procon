import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!int, c = rd[1].to!long;
  auto a = readln.split.to!(int[]);

  auto m = new mint[][](n, n), u = new mint[][](n, n);

  foreach (i; 0..n)
    foreach (j; 0..n)
      if (j <= i) m[i][j] = a[j];

  foreach (i; 0..n) u[i][i] = 1;

  auto r = repeatedSquare!(mint[][], matMul, long)(m, c, u);

  auto ans = mint(0);
  foreach (i; 0..n) ans += r[n-1][i] - r[i][i];

  writeln(ans);
}

T[][] matMul(T)(const T[][] a, const T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m) {
    static if (T.init != 0) c[i][] = 0;
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  }
  return c;
}

pure T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

  static init() { return FactorRing!(m, pos)(0); }

  @property int toInt() { return vi; }
  alias toInt this;

  this(int v) { vi = v; }
  this(int v, bool runMod) { vi = runMod ? mod(v) : v; }
  this(long v) { vi = mod(v); }

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

  static if (!pos) {
    pure auto opUnary(string op: "-")() const { return FactorRing!(m, pos)(mod(-vi)); }
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
