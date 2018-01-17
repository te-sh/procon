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

  pure auto opBinary(string op: "/")(FR r) { return FR(mod(vl*r.inv.vi)); }
  pure auto opBinary(string op: "/")(int r) { return opBinary!op(FR(r)); }
  ref auto opOpAssign(string op: "/")(ref FR r) { vi = mod(vl*r.inv.vi); return this; }
  ref auto opOpAssign(string op: "/")(int r) { return opOpAssign!op(FR(r)); }

  pure auto inv()
  {
    import ex_euclid;
    int x = vi, a, b;
    exEuclid(x, m, a, b);
    return FR(mod(a));
  }
}

unittest
{
  import std.algorithm, std.array, std.conv;
  alias FactorRing!(2_000_000_000) mint;

  assert(mint.init == 0);
  assert(5.to!mint == mint(5));

  assert(mint(2_100_000_001, true) == 100_000_001);
  assert(mint(2_100_000_001, true) > 100_000_000);
  assert(mint(2_100_000_000, true) < 100_000_002);

  auto a = new mint[](1);
  a[0] = 1;
  assert(a[0] == 1);
  a[0] += 3;
  assert(a[0] == 4);
  a[0] -= 1;
  assert(a[0] == 3);
  a[0] *= 3;
  assert(a[0] == 9);

  assert(-mint(1_999_999_999) == 1);

  assert(mint(1_800_000_000) + mint(1_700_000_000) == 1_500_000_000);
  assert(mint(1_800_000_000) * (-1) - mint(1_700_000_000) == 500_000_000);
  assert(mint(123_456_789) * mint(123_456_789) == 750_190_521);

  assert(mint(1_800_000_000) + 1_700_000_000 == 1_500_000_000);
  assert(mint(1_800_000_000) * (-1) - 1_700_000_000 == 500_000_000);
  assert(mint(123_456_789) * 123_456_789 == 750_190_521);

  assert(FactorRing!11(6) / FactorRing!11(3) == 2);
  assert(FactorRing!11(6) / 3 == 2);

  assert(FactorRing!11(3).inv == 4);
  assert(FactorRing!7(4).inv == 2);

  mint[] b = [1, 2, 3].map!(to!mint).array;
  assert(b.sum == 6);
}
