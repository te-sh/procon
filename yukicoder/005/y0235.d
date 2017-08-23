import std.algorithm, std.conv, std.range, std.stdio, std.string;

const mod = 10 ^^ 9 + 7;
alias FactorRing!mod mint;
alias SegmentTreeLazy!(mint, mint(0), "a + b") segtree;
alias CulSum!mint culSum;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto s = new mint[](n), c = new mint[](n);
  auto rds = readln.chomp.splitter, rdc = readln.chomp.splitter;
  foreach (i; 0..n) {
    s[i] = rds.front.to!int; rds.popFront();
    c[i] = rdc.front.to!int; rdc.popFront();
  }

  auto tree = Tree(n);
  foreach (_; 0..n-1) {
    auto rd = readln.split.to!(size_t[]), a = rd[0]-1, b = rd[1]-1;
    tree.addEdge(a, b);
  }

  tree.rootify(0);
  tree.makePath(0);

  auto np = tree.paths.length;
  auto css = new culSum*[](np), csc = new culSum*[](np);
  auto stl = new segtree*[](np);
  foreach (i; 0..np) {
    css[i] = new culSum(s.indexed(tree.paths[i]).array);
    csc[i] = new culSum(c.indexed(tree.paths[i]).array);
    auto npi = tree.paths[i].length;
    stl[i] = new segtree(npi);
    stl[i].weight = *csc[i];
  }

  auto q = readln.chomp.to!size_t;
  foreach (_; 0..q) {
    auto rd = readln.chomp.splitter;
    auto km = rd.front.to!int; rd.popFront();
    auto x = rd.front.to!size_t-1; rd.popFront();
    auto y = rd.front.to!size_t-1; rd.popFront();

    auto lca = tree.lca(x, y);
    if (y == lca) swap(x, y);

    auto calc0(size_t u, size_t v, int z, bool includeU) {
      while (tree.path[u] != tree.path[v]) {
        auto d = tree.depthInPath(v);
        auto p = tree.path[v];
        (*stl[p])[0..d+1] += mint(z);
        v = tree.parent[tree.head[v]];
      }

      auto d1 = tree.depthInPath(u), d2 = tree.depthInPath(v);
      auto p = tree.path[u];
      if (includeU)
        (*stl[p])[d1..d2+1] += mint(z);
      else if (d1 < d2)
        (*stl[p])[d1+1..d2+1] += mint(z);
    }

    auto calc1(size_t u, size_t v, bool includeU) {
      auto r = mint(0);

      while (tree.path[u] != tree.path[v]) {
        auto d = tree.depthInPath(v);
        auto p = tree.path[v];
        r += (*stl[p])[0..d+1] + (*css[p])[0..d+1];
        v = tree.parent[tree.head[v]];
      }

      auto d1 = tree.depthInPath(u), d2 = tree.depthInPath(v);
      auto p = tree.path[u];
      if (includeU)
        r += (*stl[p])[d1..d2+1] + (*css[p])[d1..d2+1];
      else if (d1 < d2)
        r += (*stl[p])[d1+1..d2+1] + (*css[p])[d1+1..d2+1];

      return r;
    }

    switch (km) {
    case 0:
      auto z = rd.front.to!int;
      if (x == lca) {
        calc0(x, y, z, true);
      } else {
        calc0(lca, x, z, true);
        calc0(lca, y, z, false);
      }
      break;
    case 1:
      auto r = mint(0);
      if (x == lca) {
        r += calc1(x, y, true);
      } else {
        r += calc1(lca, x, true);
        r += calc1(lca, y, false);
      }
      writeln(r);
      break;
    default:
      assert(0);
    }
  }
}

struct CulSum(T)
{
  T[] buf;

  this(T[] a)
  {
    buf = new T[](a.length + 1);
    buf[1..$][] = a[];
    foreach (i; 0..a.length)
      buf[i+1] += buf[i];
  }

  T opSlice(size_t l, size_t r)
  {
    return buf[r] - buf[l];
  }
}

struct SegmentTreeLazy(T, T unit, alias pred = "a + b")
{
  import core.bitop, std.conv, std.functional, std.range;
  alias predFun = binaryFun!pred;
  enum Op { none, add };

  const size_t n, an;
  T[] buf, laz;
  Op[] op;

  CulSum!mint weight;

  this(size_t n)
  {
    this.n = n;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    laz = new T[](an * 2);
    op = new Op[](an * 2);
    static if (T.init != unit) {
      buf[] = unit;
    }
  }

  void propagate(size_t k, size_t nl, size_t nr)
  {
    if (op[k] == Op.none) return;

    size_t nm = (nl + nr) / 2;
    setLazy(op[k], laz[k], k*2,   nl, nm);
    setLazy(op[k], laz[k], k*2+1, nm, nr);

    op[k] = Op.none;
  }

  void setLazy(Op nop, T val, size_t k, size_t nl, size_t nr)
  {
    switch (nop) {
    case Op.add:
      buf[k] += val * weight[nl..nr];
      laz[k] = op[k] == Op.none ? val : laz[k] + val;
      op[k] = Op.add;
      break;
    default:
      assert(0);
    }
  }

  void addOpe(Op op, T val, size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return;

    if (l <= nl && nr <= r) {
      setLazy(op, val, k, nl, nr);
      return;
    }

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    addOpe(op, val, l, r, k*2,   nl, nm);
    addOpe(op, val, l, r, k*2+1, nm, nr);

    buf[k] = predFun(buf[k*2], buf[k*2+1]);
  }

  void opSliceOpAssign(string op: "+")(T val, size_t l, size_t r)
  {
    addOpe(Op.add, val, l, r, 1, 0, an);
  }

  T summary(size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return unit;

    if (l <= nl && nr <= r) return buf[k];

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    auto vl = summary(l, r, k*2,   nl, nm);
    auto vr = summary(l, r, k*2+1, nm, nr);

    return predFun(vl, vr);
  }

  T opSlice(size_t l, size_t r)
  {
    return summary(l, r, 1, 0, an);
  }

  pure size_t opDollar() const { return n; }
}

struct Tree
{
  import std.container;

  size_t n;
  size_t[][] adj;
  int[] size, depth;
  size_t[] head, parent, path;
  size_t[][] paths;

  this(size_t n)
  {
    this.n = n;
    adj = new size_t[][](n);
  }

  auto addEdge(size_t s, size_t t)
  {
    adj[s] ~= t;
    adj[t] ~= s;
  }

  auto rootify(size_t r)
  {
    parent = new size_t[](n);
    depth = new int[](n);
    depth[] = -1;

    struct UP { size_t u, p; }
    auto st1 = SList!UP(UP(r, r));
    auto st2 = SList!UP();
    while (!st1.empty) {
      auto up = st1.front, u = up.u, p = up.p; st1.removeFront();

      parent[u] = p;
      depth[u] = depth[p] + 1;

      foreach (v; adj[u])
        if (v != p) {
          st1.insertFront(UP(v, u));
          st2.insertFront(UP(v, u));
        }
    }

    size = new int[](n);
    size[] = 1;

    while (!st2.empty) {
      auto up = st2.front, u = up.u, p = up.p; st2.removeFront();
      size[p] += size[u];
    }

    head = new size_t[](n);
    head[] = n;

    struct US { size_t u, s; }
    auto st = SList!US(US(r, r));

    while (!st.empty) {
      auto us = st.front, u = us.u, s = us.s; st.removeFront();

      head[u] = s;
      auto z = n;
      foreach (v; adj[u])
        if (head[v] == n && (z == n || size[z] < size[v])) z = v;

      foreach (v; adj[u])
        if (head[v] == n) st.insertFront(US(v, v == z ? s : v));
    }
  }

  auto makePath(size_t r)
  {
    auto pathIndex = 0;
    path = new size_t[](n);

    auto q = DList!size_t(r);

    while (!q.empty) {
      auto u = q.front; q.removeFront();

      if (u == head[u]) {
        path[u] = pathIndex++;
        paths ~= [u];
      } else {
        path[u] = path[head[u]];
        paths[path[u]] ~= u;
      }

      foreach (v; adj[u])
        if (v != parent[u]) q.insertBack(v);
    }
  }

  auto depthInPath(size_t n)
  {
    return depth[n] - depth[head[n]];
  }

  auto lca(size_t u, size_t v)
  {
    while (head[u] != head[v])
      if (depth[head[u]] < depth[head[v]]) v = parent[head[v]];
      else                                 u = parent[head[u]];
    return depth[u] < depth[v] ? u : v;
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
