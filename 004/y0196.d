import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags

const p = 10^^9 + 7;
alias FactorRing!p mint;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, k = rd1[1].to!int;

  auto ci = new size_t[][](n);
  foreach (_; 0..n-1) {
    auto rd2 = readln.split.to!(size_t[]), s = rd2[0], t = rd2[1];
    ci[s] ~= t;
    ci[t] ~= s;
  }

  auto r = dfs(ci, n), wi = r[1]; ci = r[0];

  auto cci = new size_t[](n);
  foreach (i, c; ci)
    cci[i] = c.length;

  auto di = new size_t[](n);
  foreach (w; wi)
    di[w] = ci[w].map!(c => di[c]).sum + 1;

  auto dp1 = new mint[][](n, k+1);
  foreach (w; wi) {
    auto dp2 = new mint[][](cci[w]+1, k+1);
    foreach (d; dp2)
      d[0] = mint(1);

    auto ds = size_t(0);
    foreach (i, c; ci[w]) {
      auto dt = ds + di[c];
      foreach (m; 1..min(dt, k)+1)
        foreach (j; max(0, m.to!int-ds.to!int)..min(m, di[c])+1) {
          dp2[i+1][m] += dp2[i][m-j] * dp1[c][j];
        }
      ds = dt;
    }

    auto lk = min(di[w]+1, k+1);
    dp1[w][0..lk] = dp2[cci[w]][0..lk];

    if (k >= di[w])
      dp1[w][di[w]] = 1;
  }

  writeln(dp1[0][k]);
}

auto dfs(size_t[][] ci, size_t n)
{
  size_t[] wi;
  size_t[][] di = new size_t[][](n);
  bool[] bi = new bool[](n);
  
  auto st = new SList!size_t(0);
  bi[0] = true;

  while (!st.empty) {
    auto s = st.front; st.removeFront();
    wi ~= s;
    foreach (c; ci[s])
      if (!bi[c]) {
        di[s] ~= c;
        st.insertFront(c);
        bi[c] = true;
      }
  }

  wi.reverse();
  return Tuple!(size_t[][], size_t[])(di, wi);
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
