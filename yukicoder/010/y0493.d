import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

const mod = 10^^9+7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto mk = 60;
  auto sd = new string[](mk+1), ld = new long[](mk+1);
  auto s = new long[](mk+1), ts = new ulong[](mk+1), tp = new mint[](mk+1);
  tp[0] = 1;

  foreach (i; 1..mk+1) {
    sd[i] = (i^^2).to!string;
    ld[i] = sd[i].length.to!long;
    s[i] = s[i-1]*2+ld[i];
    ts[i] = ts[i-1]+ts[i-1]+calcSum(sd[i]);
    tp[i] = tp[i-1]*tp[i-1]*calcProd(sd[i]);
  }

  Tuple!(ulong, mint) calc(int k, long l, long r)
  {
    if (l == 0 && r == s[k]) return tuple(ts[k], tp[k]);

    Tuple!(ulong, mint) ans;
    if (l < s[k-1]) {
      if (r <= s[k-1]) {
        ans = calc(k-1, l, r);
      } else if (r <= s[k-1]+ld[k]) {
        auto c = calc(k-1, l, s[k-1]), sdi = sd[k][0..r-s[k-1]];
        ans = tuple(c[0] + calcSum(sdi), c[1] * calcProd(sdi));
      } else {
        auto c1 = calc(k-1, l, s[k-1]), c2 = calc(k-1, 0, r-s[k-1]-ld[k]);
        ans = tuple(c1[0] + c2[0] + calcSum(sd[k]), c1[1] * c2[1] * calcProd(sd[k]));
      }
    } else if (l < s[k-1]+ld[k]) {
      if (r <= s[k-1]+ld[k]) {
        auto sdi = sd[k][l-s[k-1]..r-s[k-1]];
        ans = tuple(calcSum(sdi), calcProd(sdi));
      } else {
        auto sdi = sd[k][l-s[k-1]..$], c = calc(k-1, 0, r-s[k-1]-ld[k]);
        ans = tuple(c[0] + calcSum(sdi), c[1] * calcProd(sdi));
      }
    } else {
      ans = calc(k-1, l-s[k-1]-ld[k], r-s[k-1]-ld[k]);
    }
    return ans;
  }

  auto rd = readln.split, k = rd[0].to!int, l = rd[1].to!long, r = rd[2].to!long;
  if (k > mk) k = mk;

  if (r > s[k]) {
    writeln(-1);
    return;
  }

  auto ans = calc(k, l-1, r);
  writeln(ans[0], " ", ans[1]);
}

auto calcSum(string s)
{
  auto r = ulong(0);
  foreach (c; s) {
    auto d = cast(int)(c-'0');
    r += mint(d == 0 ? 10 : d);
  }
  return r;
}

auto calcProd(string s)
{
  auto r = mint(1);
  foreach (c; s) {
    auto d = cast(int)(c-'0');
    r *= mint(d == 0 ? 10 : d);
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
