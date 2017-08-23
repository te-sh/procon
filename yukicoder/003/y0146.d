import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto p = 10^^9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto r = mint(0);
  foreach (_; n.iota) {
    auto rd = readln.split.to!(long[]), c = rd[0], d = rd[1];
    r = r + mint((c + 1) / 2) * mint(d);
  }

  writeln(r.toInt);
}

struct FactorRing(int m) {
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

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
}
