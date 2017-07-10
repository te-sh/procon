import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 1000;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;

  if (n == 0) {
    writeln(1);
    return;
  }

  auto a = [[mint(1),mint(3)],[mint(1),mint(1)]];
  auto u = [[mint(1),mint(0)],[mint(0),mint(1)]];
  auto b = repeatedSquare!(mint[][], matMul!mint)(a, n-1, u);
  auto r = (b[0][0] + b[0][1]) * 2;

  if (n % 2 == 0) r -= 1;

  writeln(r);
}

T[][] matMul(T)(T[][] a, T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m)
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  return c;
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
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
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!(m, pos) opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const
  {
    static if (pos) return _v % m;
    else return (_v % m + m) % m;
  }

  pure auto opBinary(string op: "+")(long rhs) const { return FactorRing!(m, pos)(v + rhs); }
  pure auto opBinary(string op: "-")(long rhs) const { return FactorRing!(m, pos)(v - rhs); }
  pure auto opBinary(string op: "*")(long rhs) const { return FactorRing!(m, pos)(v * rhs); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.v); }

  auto opOpAssign(string op: "+")(long rhs) { v = mod(v + rhs); }
  auto opOpAssign(string op: "-")(long rhs) { v = mod(v - rhs); }
  auto opOpAssign(string op: "*")(long rhs) { v = mod(v * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.v); }
}
