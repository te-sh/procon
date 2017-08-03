import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias FactorRing!mod mint;

version(unittest) {} else
void main()
{
  auto rd = readln.split, n = rd[0].to!size_t, k = rd[1].to!long;
  auto a = readln.split.to!(int[]);

  auto sfn = toFactorNumberSystem(a);
  auto efn = addToFactorNumberSystem(sfn, k);

  auto sr = calcDp(sfn), er = calcDp(efn[0..$-1]);

  auto lfn = new long[](n); lfn[$-1] = 1;
  auto lr = calcDp(lfn);

  writeln(er - sr + lr * mint(efn[$-1]));
}

auto toFactorNumberSystem(int[] a)
{
  auto n = a.length, bt = BiTree!int(n), r = new long[](n-1);
  bt[a[$-1]] += 1;

  foreach (i; 0..n-1) {
    auto ai = a[$-i-2];
    r[i] = bt[0..ai];
    bt[ai] += 1;
  }

  return r;
}

auto addToFactorNumberSystem(long[] fn, long k)
{
  auto n = fn.length, r = new long[](n+1);
  r[0..$-1][] = fn[];
  r[0] += k;

  foreach (i; 0..n) {
    r[i+1] += r[i]/(i+2);
    r[i] %= i+2;
  }

  return r;
}

auto calcDp(long[] fn)
{
  auto n = fn.length, dp1 = new mint[][](n+1, 2), dp2 = new mint[](n+1);

  foreach (i; 0..n) {
    auto fni = fn[$-i-1], dm = n-i;
    dp1[i+1][0] = dp1[i][0] * mint(dm+1) + dp2[i] * mint(dm*(dm+1)/2) + dp1[i][1] * fni + mint(fni*(fni-1)/2);
    dp1[i+1][1] = dp1[i][1] + fni;
    dp2[i+1] = dp2[i] * (dm+1) + fni;
  }

  return dp1[n][0];
}

struct BiTree(T)
{
  const size_t n;
  T[] buf;

  this(size_t n)
  {
    this.n = n;
    this.buf = new T[](n + 1);
  }

  void opIndexOpAssign(string op: "+")(T val, size_t i)
  {
    ++i;
    for (; i <= n; i += i & -i)
      buf[i] += val;
  }

  pure T opSlice(size_t r, size_t l) const
  {
    return get(l) - get(r);
  }

  pure size_t opDollar() const { return n; }
  pure T opIndex(size_t i) const { return opSlice(i, i+1); }

private:

  pure T get(size_t i) const
  {
    auto s = T(0);
    for (; i > 0; i -= i & -i)
      s += buf[i];
    return s;
  }
}

struct FactorRing(int m, bool pos = false)
{
  long v;

  @property int toInt() { return v.to!int; }
  alias toInt this;

  this(T)(T _v) { v = mod(_v); }

  ref FactorRing!(m, pos) opAssign(int _v)
  {
    v = mod(_v);
    return this;
  }

  pure auto mod(long _v) const
  {
    static if (pos) return _v % m;
    else return (_v % m + m) % m;
  }

  pure auto opBinary(string op: "+")(long rhs) const { return FactorRing!(m, pos)(v + rhs); }
  pure auto opBinary(string op: "-")(long rhs) const { return FactorRing!(m, pos)(v - rhs); }
  pure auto opBinary(string op: "*")(long rhs) const { return FactorRing!(m, pos)(v * rhs); }

  pure auto opBinary(string op)(FactorRing!(m, pos) rhs) const
    if (op == "+" || op == "-" || op == "*") { return opBinary!op(rhs.v); }

  auto opOpAssign(string op: "+")(long rhs) { v = mod(v + rhs); }
  auto opOpAssign(string op: "-")(long rhs) { v = mod(v - rhs); }
  auto opOpAssign(string op: "*")(long rhs) { v = mod(v * rhs); }

  auto opOpAssign(string op)(FactorRing!(m, pos) rhs)
    if (op == "+" || op == "-" || op == "*") { return opOpAssign!op(rhs.v); }
}
