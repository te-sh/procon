import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 10 ^^ 9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), h = rd[0], w = rd[1];
  auto sij = h.iota.map!(_ => readln.chomp.map!(c => c.predSwitch('0', 0, '1', 1, '?', 2)).array).array;
  auto r1 = calc1(sij, h, w), r2 = calc2(sij, h, w), r3 = calc3(sij, h, w);
  writeln(r1 + r2 - r3);
}

auto calc1(int[][] sij, size_t h, size_t w)
{
  mint r = 1;
  foreach (x; 0..w)
    r *= can0101(sij.transversal(x));
  return r;
}

auto calc2(int[][] sij, size_t h, size_t w)
{
  mint r = 1;
  foreach (y; 0..h)
    r *= can0101(sij[y]);
  return r;
}

auto calc3(int[][] sij, size_t h, size_t w)
{
  mint r = 0;
  if (sij.enumerate.all!(c => c.value.enumerate.all!(d => d.value == 2 || (c.index + d.index) % 2 == d.value))) ++r;
  if (sij.enumerate.all!(c => c.value.enumerate.all!(d => d.value == 2 || (c.index + d.index) % 2 != d.value))) ++r;
  return r;
}

auto can0101(R)(R s)
{
  auto r = 0;
  if (s.enumerate.all!(c => c.value == 2 || c.value == c.index % 2)) ++r;
  if (s.enumerate.all!(c => c.value == 2 || c.value != c.index % 2)) ++r;
  return r;
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

  pure auto opBinary(string op: "+")(int rhs) const { return FactorRing!m(v + rhs); }
  pure auto opBinary(string op: "-")(int rhs) const { return FactorRing!m(v - rhs); }
  pure auto opBinary(string op: "*")(int rhs) const { return FactorRing!m(v * rhs); }

  pure auto opBinary(string op)(FactorRing!m rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.v); }

  auto opOpAssign(string op: "+")(int rhs) { v = mod(v + rhs); }
  auto opOpAssign(string op: "-")(int rhs) { v = mod(v - rhs); }
  auto opOpAssign(string op: "*")(int rhs) { v = mod(v * rhs); }

  auto opOpAssign(string op)(FactorRing!m rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.v); }
}
