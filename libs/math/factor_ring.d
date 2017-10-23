struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

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

  pure auto opBinary(string op: "/")(FactorRing!(m, pos) rhs) { return FactorRing!(m, pos)(mod(vl * rhs.inv.vi)); }
  pure auto opBinary(string op: "/")(int rhs) { return opBinary!op(FactorRing!(m, pos)(rhs)); }
  auto opOpAssign(string op: "/")(FactorRing!(m, pos) rhs) { vi = mod(vl * rhs.inv.vi); }
  auto opOpAssign(string op: "/")(int rhs) { return opOpAssign!op(FactorRing!(m, pos)(rhs)); }

  pure auto inv() const
  {
    import ex_euclid;
    int x = vi, a, b;
    exEuclid(x, m, a, b);
    return FactorRing!(m, pos)(mod(a));
  }
}

unittest
{
  alias FactorRing!(2_000_000_000) mint;

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

  assert(FactorRing!11(3).inv == 4);
  assert(FactorRing!7(4).inv == 2);
}
