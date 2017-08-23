import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias FactorRing!573 mint;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;

  auto hi = new int[](26);
  foreach (c; s) ++hi[c - 'A'];
  hi.sort!"a > b";

  auto dp = new mint[][](s.length + 2, s.length + 1);
  foreach (n; 1..s.length + 2) dp[n][0] = mint(1);
  foreach (m; 0..s.length + 1) dp[1][m] = mint(1);

  foreach (n; 2..s.length + 2)
    foreach (m; 1..s.length + 1)
      dp[n][m] = dp[n-1][m] + dp[n][m - 1];

  auto r = mint(1);
  auto l = hi.front;
  foreach (h; hi.drop(1)) {
    if (h == 0) break;
    r = r * dp[l + 1][h];
    l += h;
  }

  writeln(r - 1);
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

  auto opBinary(string op)(int rhs)
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(FactorRing!m(rhs)); }
}
