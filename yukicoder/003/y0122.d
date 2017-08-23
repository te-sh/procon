import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;
alias FactorRing!p mint;

const vr = 20001;

version(unittest) {} else
void main()
{
  auto rd = 7.iota.map!(_ => readln.split.to!(int[])).map!(ia => MinMax(ia[0], ia[1])).array;
  auto eia = rd.indexed([0, 2, 4, 6]).array;
  auto oia = rd.indexed([1, 3, 5]).array;

  auto r = calc(eia, oia) + calc(oia, eia);
  writeln(r);
}

auto calc(MinMax[] a1, MinMax[] a2)
{
  auto b1 = new mint[][](a1.length, vr);
  foreach (i, a; a1) {
    auto c = a1[0..i] ~ a1[i+1..$];
    foreach_reverse (v; a.mi..a.ma+1) {
      auto cia = c.map!(ai => MinMax(max(v + 1, ai.mi), ai.ma)).array;
      b1[i][v] = cia.combis;
    }
  }
  auto b1sum = new mint[][](a1.length, vr);
  foreach (i, b; b1)
    foreach_reverse (v; 1..vr-1)
      b1sum[i][v] = b1sum[i][v+1] + b1[i][v];

  auto b2 = new mint[][](a2.length, vr);
  foreach (i, a; a2) {
    auto c = a2[0..i] ~ a2[i+1..$];
    foreach (v; a.mi..a.ma+1) {
      auto cia = c.map!(ai => MinMax(ai.mi, min(v - 1, ai.ma))).array;
      b2[i][v] = cia.combis;
    }
  }

  auto r = mint(0);
  foreach (v; 1..vr-1) {
    auto c1 = b1sum.map!(b => b[v+1]).fold!"a + b";
    auto c2 = b2.map!(b => b[v]).fold!"a + b";
    r = r + c1 * c2;
  }

  return r;
}

auto combis(MinMax[] ias)
{
  auto b = ias.map!(ai => ai.rangeLen).map!(r => mint(r)).array.fold!"a * b";
  if (ias.length == 2) {
    auto r = mint(ias.intersect.rangeLen);
    b = b - r;
  } else {
    auto r1 = mint([ias[0], ias[1]].intersect.rangeLen);
    auto r2 = mint([ias[1], ias[2]].intersect.rangeLen);
    auto r3 = mint([ias[2], ias[0]].intersect.rangeLen);
    auto r4 = mint(ias.intersect.rangeLen);
    b = b
      - r1 * ias[2].rangeLen
      - r2 * ias[0].rangeLen
      - r3 * ias[1].rangeLen
      + r4 * 2;
  }
  return b;
}

auto intersect(MinMax[] ias)
{
  return MinMax(ias.map!"a.mi".maxElement, ias.map!"a.ma".minElement);
}

auto rangeLen(MinMax ia)
{
  return ia.mi > ia.ma ? 0 : ia.ma - ia.mi + 1;
}

struct MinMax
{
  int mi, ma;
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

  pure auto opBinary(string op: "+")(FactorRing!m rhs) const { return FactorRing!m(v + rhs.v); }
  pure auto opBinary(string op: "-")(FactorRing!m rhs) const { return FactorRing!m(v - rhs.v); }
  pure auto opBinary(string op: "*")(FactorRing!m rhs) const { return FactorRing!m(v * rhs.v); }

  pure auto opBinary(string op)(int rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(FactorRing!m(rhs)); }
}
