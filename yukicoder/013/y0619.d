import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10^^9+7;
alias mint = FactorRing!mod;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int, n2 = (n+1)/2;

  auto e = new Elem[](n2);
  auto rd1 = readln.splitter;
  foreach (i; 0..n2-1) {
    auto a = rd1.front.to!int; rd1.popFront();
    auto add = rd1.front == "+"; rd1.popFront();
    e[i] = Elem(add, mint(a));
  }
  e[n2-1] = Elem(true, mint(rd1.front.to!int));

  auto st = SegmentTree!(Elem, mergeElem)(e, Elem(true));

  auto q = readln.chomp.to!int;
  foreach (_; 0..q) {
    auto rd2 = readln.splitter;
    auto t = rd2.front; rd2.popFront();
    auto x1 = rd2.front.to!int-1; rd2.popFront();
    auto x2 = rd2.front.to!int-1;

    if (t == "!") {
      auto e1 = st[x1/2], e2 = st[x2/2];
      if (x1 & 1)
        swap(e1.add, e2.add);
      else
        swap(e1.a, e2.a);
      st[x1/2] = e1;
      st[x2/2] = e2;
    } else {
      writeln(st[x1/2..x2/2+1].value);
    }
  }
}

struct Elem
{
  bool empty, one, add;
  mint a, b, c;

  pure this(bool one, bool add, mint a, mint b, mint c)
  {
    this.one = one;
    this.add = add;
    this.a = a;
    this.b = b;
    this.c = c;
  }

  pure this(bool empty) { this.empty = true; }
  pure this(bool add, mint a) { this(true, add, a, mint(0), mint(0)); }
  pure this(bool add, mint a, mint b, mint c) { this(false, add, a, b, c); }

  pure value() { return a + b + c; }
}

pure Elem mergeElem(Elem x, Elem y)
{
  if (y.empty) {
    return x;
  } else if (x.empty) {
    return y;
  } else if (x.one && y.one) {
    if (x.add) {
      return Elem(y.add, x.a, mint(0), y.a);
    } else {
      return Elem(y.add, x.a * y.a);
    }
  } else if (x.one && !y.one) {
    if (x.add) {
      return Elem(y.add, x.a, y.a + y.b, y.c);
    } else {
      return Elem(y.add, x.a * y.a, y.b, y.c);
    }
  } else if (!x.one && y.one) {
    if (x.add) {
      return Elem(y.add, x.a, x.b + x.c, y.a);
    } else {
      return Elem(y.add, x.a, x.b, x.c * y.a);
    }
  } else {
    if (x.add) {
      return Elem(y.add, x.a, x.b + x.c + y.a + y.b, y.c);
    } else {
      return Elem(y.add, x.a, x.b + x.c * y.a + y.b, y.c);
    }
  }
}

struct SegmentTree(T, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;
  T unit;

  this(size_t n, T unit = T.init)
  {
    this.n = n;
    this.unit = unit;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    if (T.init != unit) {
      buf[] = unit;
    }
  }

  this(T[] init, T unit = T.init)
  {
    this(init.length, unit);
    buf[an..an+n][] = init[];
    foreach_reverse (i; 1..an)
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
  }

  void opIndexAssign(T val, size_t i)
  {
    buf[i += an] = val;
    while (i /= 2)
      buf[i] = predFun(buf[i * 2], buf[i * 2 + 1]);
  }

  pure T opSlice(size_t l, size_t r)
  {
    l += an; r += an;
    T r1 = unit, r2 = unit;
    while (l != r) {
      if (l % 2) r1 = predFun(r1, buf[l++]);
      if (r % 2) r2 = predFun(buf[--r], r2);
      l /= 2; r /= 2;
    }
    return predFun(r1, r2);
  }

  pure size_t opDollar() { return n; }
  pure T opIndex(size_t i) { return buf[i + an]; }
}

struct FactorRing(int m, bool pos = false)
{
  version(BigEndian) {
    union { long vl; struct { int vi2; int vi; } }
  } else {
    union { long vl; int vi; }
  }

  static init() { return FactorRing!(m, pos)(0); }

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
}
