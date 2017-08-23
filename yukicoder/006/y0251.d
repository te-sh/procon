import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.bigint;    // BigInt

const p = 129402307;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto nb = readln.chomp.to!BigInt;
  auto mb = readln.chomp.to!BigInt;

  if (nb == 0) {
    writeln(0);
    return;
  }

  if (mb == 0) {
    writeln(1);
    return;
  }

  auto n = mint((nb % p).to!int);
  auto m = (mb % (p - 1)).to!int;

  if (n == 0) {
    writeln(0);
  } else {
    writeln(repeatedSquare(n, m).to!int);
  }
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n)
{
  return repeatedSquare(a, n, T(1));
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

struct FactorRing(int m)
{
  int _m = m;
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!m opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const { return (_v % m + m) % m; }

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
