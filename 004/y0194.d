import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

const p = 10 ^^ 9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), n = rd[0], k = rd[1];
  auto ai = readln.split.to!(int[]).map!(to!mint).array;

  Tuple!(mint, mint) r;

  if (k <= 10 ^^ 6)
    r = calc1(n, k, ai);
  else
    r = calc2(n, k, ai);

  writeln(r[0], " ", r[1]);
}

auto calc1(long n, long k, mint[] ai)
{
  auto fi = new mint[](k);
  auto si = new mint[](k);

  fi[0] = ai[0];
  si[0] = ai[0];

  foreach (i; 1..n) {
    fi[i] = ai[i];
    si[i] = si[i - 1] + fi[i];
  }

  fi[n] = si[n - 1];
  si[n] = si[n - 1] + fi[n];

  foreach (i; n+1..k) {
    fi[i] = fi[i - 1] * 2 - fi[i - n - 1];
    si[i] = si[i - 1] + fi[i];
  }

  return Tuple!(mint, mint)(fi[$-1], si[$-1]);
}

auto calc2(long n, long k, mint[] ai)
{
  auto bi = ai.dup;
  bi.reverse();

  auto si = new mint[](n);
  si[0] = ai[0];
  foreach (i; 1..n)
    si[i] = si[i - 1] + ai[i];
  si.reverse();

  auto fm = new mint[][](n, n);
  fm[0][] = mint(1);
  foreach (i; 0..n-1) fm[i + 1][i] = mint(1);

  fm = pow(fm, k - n, n);
  auto f = zip(fm[0], bi).map!"a[0] * a[1]".fold!"a + b";

  auto sm = new mint[][](n + 1, n + 1);
  sm[0][0] = mint(2);
  sm[0][$-1] = mint(-1);
  foreach (i; 0..n) sm[i + 1][i] = mint(1);

  sm = pow(sm, k - n, n + 1);
  auto s = zip(sm[0], si).map!"a[0] * a[1]".fold!"a + b";

  return Tuple!(mint, mint)(f, s);
}

auto pow(T)(T[][] ai, long b, long n)
{
  auto m = b.bsr + 1;

  auto tbl = new T[][][](m, n, n);
  foreach (i; 0..n)
    tbl[0][i][] = ai[i];
  foreach (i; 1..m)
    tbl[i] = mul(tbl[i - 1], tbl[i - 1], n);

  auto r = new T[][](n, n);
  foreach (i; 0..n)
    r[i][i] = T(1);
  foreach (i; 0..m)
    if (b.bitTest(i))
      r = mul(r, tbl[i], n);

  return r;
}

auto mul(T)(T[][] ai, T[][] bi, long n)
{
  auto ci = new T[][](n, n);
  foreach (i; 0..n)
    foreach (j; 0..n)
      foreach (k; 0..n)
        ci[i][j] = ci[i][j] + ai[i][k] * bi[k][j];
  return ci;
}

pragma(inline) {
  pure bool bitTest(T)(T n, size_t i) { return (n & (T(1) << i)) != 0; }

  import core.bitop;
  pure int bsr(T)(T n) { return core.bitop.bsr(ulong(n)); }
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
  pure auto opBinary(string op: "^^")(FactorRing!m rhs) const { return pow(this, rhs.toInt); }

  pure auto opBinary(string op)(int rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(FactorRing!m(rhs)); }
}
