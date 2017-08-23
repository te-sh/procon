import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto p = 10 ^^ 9 + 7;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  alias FactorRing!p mint;
  auto pt = pascalTriangle!mint(n);
  auto st = starling2!mint(n);

  auto r = mint(0);
  foreach (k; 1..n+1) {
    foreach (j; k..n+1) {
      auto a = pt[n][j];
      auto b = st[j][k];
      auto c = mint(k * (k - 1)) ^^ (n - j).to!int;
      r = r + a * b * c;
    }
  }

  writeln(r);
}

struct FactorRing(int m) {
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!m opAssign(FactorRing!m _v) {
    v = _v.v;
    return this;
  }

  ref FactorRing!m opAssign(int _v) {
    v = mod(_v);
    return this;
  }

  auto mod(long _v) { return _v > 0 ? _v % m : ((_v % m) + m) % m; }

  auto opBinary(string op: "+")(FactorRing!m rhs) { return FactorRing!m(v + rhs.v); }
  auto opBinary(string op: "-")(FactorRing!m rhs) { return FactorRing!m(v - rhs.v); }
  auto opBinary(string op: "*")(FactorRing!m rhs) { return FactorRing!m(v * rhs.v); }
  auto opBinary(string op: "^^")(FactorRing!m rhs) { return pow(this, rhs.toInt); }

  auto opBinary(string op)(int rhs)
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(FactorRing!m(rhs)); }
  auto opBinary(string op: "^^")(int rhs) { return pow(this, rhs); }

  auto pow(FactorRing!m a, int b) {
    if (b == 0) return FactorRing!m(1);
    if (a == 0) return FactorRing!m(0);
    auto c = FactorRing!m(1);
    for (; b > 0; a = a * a, b >>= 1)
      if ((b & 1) == 1) c = c * a;
    return c;
  }
}

T[][] pascalTriangle(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + t[i - 1][j];
  }
  return t;
}

T[][] starling2(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = 0;
    t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + j.to!T * t[i - 1][j];
  }
  return t;
}
