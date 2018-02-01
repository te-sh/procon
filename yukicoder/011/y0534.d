import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

const mod1 = 10^^9+7, mod2 = 2*10^^9+16;
alias mint1 = FactorRing!mod1, mint2 = FactorRing!mod2;

version(unittest) {} else
void main()
{
  long n; readV(n);

  auto a = Matrix!mint2([[mint2(1), mint2(1)], [mint2(1), mint2(0)]]);
  auto an = repeatedSquare(a, n, Matrix!mint2.unit(2))[1][0];

  auto b = Matrix!mint1([[mint1(1), mint1(1)], [mint1(1), mint1(0)]]);
  auto bn = repeatedSquare(b, an.to!int, Matrix!mint1.unit(2))[1][0];

  writeln(bn);
}

pure T repeatedSquare(alias pred = "a * b", T, U)(T a, U n)
{
  return repeatedSquare!(pred, T, U)(a, n, T(1));
}

pure T repeatedSquare(alias pred = "a * b", T, U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  auto r = init;
  while (n > 0) {
    if (n&1) r = predFun(r, a);
    a = predFun(a, a);
    n >>= 1;
  }

  return r;
}

struct Matrix(T)
{
  size_t r, c;
  T[][] a;
  alias a this;

  static ref auto unit(size_t n)
  {
    auto r = Matrix!T(n, n);
    foreach (i; 0..n) r[i][i] = 1;
    return r;
  }

  this(size_t r, size_t c)
  {
    this.r = r; this.c = c;
    a = new T[][](r, c);
    static if (T.init != 0) foreach (i; 0..r) a[i][] = 0;
  }

  this(T[][] b)
  {
    r = b.length;
    c = b[0].length;
    a = b;
  }

  ref auto dup() { auto x = Matrix!T(r, c); foreach (i; 0..r) x[i][] = a[i][]; return x; }

  ref auto opBinary(string op)(Matrix!T b) if (op == "+" || op == "-") in { assert(r == b.r && c == b.c); } body
  {
    auto x = Matrix!T(r, c);
    foreach (i; 0..r) foreach (j; 0..c) x[i][j] = mixin("a[i][j]"~op~"b[i][j]");
    return x;
  }

  ref auto opBinary(string op: "*")(Matrix!T b) in { assert(c == b.r); } body
  {
    auto x = Matrix!T(r, b.c);
    foreach (i; 0..r) foreach (j; 0..b.c) foreach (k; 0..c) x[i][j] += a[i][k]*b[k][j];
    return x;
  }

  ref auto opBinary(string op: "*")(T[] b) in { assert(c == b.length); } body
  {
    auto x = new T[](r);
    static if (T.init != 0) x[] = 0;
    foreach (i; 0..r) foreach (j; 0..c) x[i] += a[i][j]*b[j];
    return x;
  }
}

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) union { long vl; struct { int vi2; int vi; } } else union { long vl; int vi; }
  alias FR = FactorRing!(m, pos);
  @property static init() { return FR(0); }
  @property int value() { return vi; }
  @property void value(int v) { vi = mod(v); }
  alias value this;

  this(int v) { vi = v; }
  this(int v, bool runMod) { vi = runMod ? mod(v) : v; }
  this(long v) { vi = mod(v); }

  ref auto opAssign(int v) { vi = v; return this; }

  pure auto mod(int v) const { static if (pos) return v%m; else return (v%m+m)%m; }
  pure auto mod(long v) const { static if (pos) return cast(int)(v%m); else return cast(int)((v%m+m)%m); }

  static if (!pos) pure ref auto opUnary(string op: "-")() { return FR(mod(-vi)); }

  static if (m < int.max / 2) {
    pure ref auto opBinary(string op)(int r) if (op == "+" || op == "-") { return FR(mod(mixin("vi"~op~"r"))); }
    ref auto opOpAssign(string op)(int r) if (op == "+" || op == "-") { vi = mod(mixin("vi"~op~"r")); return this; }
  } else {
    pure ref auto opBinary(string op)(int r) if (op == "+" || op == "-") { return FR(mod(mixin("vl"~op~"r"))); }
    ref auto opOpAssign(string op)(int r) if (op == "+" || op == "-") { vi = mod(mixin("vl"~op~"r")); return this; }
  }
  pure ref auto opBinary(string op: "*")(int r) { return FR(mod(vl*r)); }
  ref auto opOpAssign(string op: "*")(int r) { vi = mod(vl*r); return this; }

  pure ref auto opBinary(string op)(ref FR r) if (op == "+" || op == "-" || op == "*") { return opBinary!op(r.vi); }
  ref auto opOpAssign(string op)(ref FR r) if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(r.vi); }
}
