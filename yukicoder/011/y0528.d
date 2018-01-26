import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

const mod1 = 10^^9, mod2 = 10^^9+7;
alias mint1 = FactorRing!mod1, mint2 = FactorRing!mod2;

version(unittest) {} else
void main()
{
  auto n = readln.chomp, d = n.length.to!int;
  auto m = new int[](d);
  foreach (i; 0..d) m[i] = cast(int)(n[i]-'0');

  auto f1 = new mint1[]((d+1)/2+1), f2 = new mint2[]((d+1)/2+1);
  f1[0] = 1; f2[0] = 1;
  foreach (i; 1..(d+1)/2+1) {
    f1[i] = f1[i-1]*10;
    f2[i] = f2[i-1]*10;
  }

  auto calc()
  {
    if (d > 1 && m[0] == 1 && m[1..$].all!(mi => mi == 0))
      return tuple(mint1(0), mint2(0));

    auto i = 0;
    while (i < d/2) {
      auto j = d-i-1;
      if (m[i] <= m[j]) {
        m[j] = m[i];
        ++i;
      } else {
        m[j] = 9;
        --m[--j];
        while (m[j] < 0) {
          m[j] = 9;
          --m[--j];
        }
        i = min(i, j);
      }
    }

    auto r1 = mint1(0), r2 = mint2(0), r3 = 0L, e = (d+1)/2;
    foreach (j; 0..e) {
      r1 += f1[e-j-1]*m[j];
      r2 += f2[e-j-1]*m[j];
    }
    r1 -= f1[e-1]-1;
    r2 -= f2[e-1]-1;

    return tuple(r1, r2);
  }

  auto r = calc(), r1 = r[0], r2 = r[1];
  foreach (i; 0..d-1) {
    auto e = (i+2)/2;
    r1 += f1[e] - f1[e-1];
    r2 += f2[e] - f2[e-1];
  }

  writeln(r1);
  writeln(r2);
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
