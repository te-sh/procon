import std.algorithm, std.conv, std.range, std.stdio, std.string;

const p = 100_000_009;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto q = readln.chomp.to!size_t;
  foreach (_; q.iota) {
    auto rd = readln.split.to!(int[]);
    auto seed = rd[0], n = rd[1], k = rd[2], b = rd[3];

    auto fs = factors(b);

    auto xi = new mint[](n + 1);
    xi[0] = seed;
    foreach (i; n.iota)
      xi[i + 1] = xi[i] * (xi[i] + 12345) + 1;

    auto r = int.max;
    foreach (f; fs) {
      auto pi = xi.map!(x => hasPower(x, f.index)).array;
      auto s = pi.sort().take(k).sum;
      r = min(r, s / f.value);
    }

    writeln(r);
  }
}

auto factors(int b)
{
  auto r = new int[](32);
 loop: while (b > 1)
    foreach (p; 2..b+1)
      if (b % p == 0) {
        ++r[p];
        b /= p;
        continue loop;
      }
  return r.enumerate!int.filter!"a[1] > 0";
}

auto hasPower(int a, int b)
{
  auto r = 0;
  for (; a > 0 && a % b == 0; a /= b) ++r;
  return r;
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
