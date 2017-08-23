import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias SegmentTreeLazy!(long, 0) SegTree;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto tree = Tree(n);
  foreach (_; 0..n-1) {
    auto rd = readln.split.to!(size_t[]), u = rd[0]-1, v = rd[1]-1;
    tree.addEdge(u, v);
  }

  tree.rootify(0);
  tree.makePath(0);

  auto np = tree.paths.length;
  auto segTrees = new SegTree*[](np);
  foreach (i; 0..np) segTrees[i] = new SegTree(tree.paths[i].length);

  auto calc(size_t a, size_t b, bool includeFirst)
  {
    auto r = 0L;

    while (tree.path[a] != tree.path[b]) {
      auto pb = tree.path[b];
      auto db = tree.depthInPath(b);
      (*segTrees[pb])[0..db+1] += 1;
      r += (*segTrees[pb])[0..db+1];
      b = tree.parent[tree.head[b]];
    }

    auto p = tree.path[a];
    auto da = tree.depthInPath(a), db = tree.depthInPath(b);
    if (includeFirst) {
      (*segTrees[p])[da..db+1] += 1;
      r += (*segTrees[p])[da..db+1];
    } else if (da < db) {
      (*segTrees[p])[da+1..db+1] += 1;
      r += (*segTrees[p])[da+1..db+1];
    }

    return r;
  }

  auto q = readln.chomp.to!size_t, r = 0L;
  foreach (_; 0..q) {
    auto rd = readln.split.to!(size_t[]), a = rd[0]-1, b = rd[1]-1;
    auto l = tree.lca(a, b);
    if (l == b) swap(a, b);

    if (l == a) {
      r += calc(a, b, true);
    } else {
      r += calc(l, a, true);
      r += calc(l, b, false);
    }
  }

  writeln(r);
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

struct SegmentTreeLazy(T, T unit, alias pred = "a + b")
{
  import core.bitop, std.conv, std.functional, std.range;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf, laz;
  bool[] op;

  this(size_t n)
  {
    this.n = n;
    an = (1 << ((n - 1).bsr + 1));
    buf = new T[](an * 2);
    laz = new T[](an * 2);
    op = new bool[](an * 2);
    static if (T.init != unit) {
      buf[] = unit;
    }
  }

  void propagate(size_t k, size_t nl, size_t nr)
  {
    if (!op[k]) return;

    size_t nm = (nl + nr) / 2;
    setLazy(laz[k], k*2,   nl, nm);
    setLazy(laz[k], k*2+1, nm, nr);

    op[k] = false;
  }

  void setLazy(T val, size_t k, size_t nl, size_t nr)
  {
    buf[k] += val * (nr - nl).to!T;
    laz[k] = op[k] ? laz[k] + val : val;
    op[k] = true;
  }

  void addOpe(T val, size_t l, size_t r, size_t k, size_t nl, size_t nr)
  {
    if (nr <= l || r <= nl) return;

    if (l <= nl && nr <= r) {
      setLazy(val, k, nl, nr);
      return;
    }

    propagate(k, nl, nr);

    auto nm = (nl + nr) / 2;
    addOpe(val, l, r, k*2,   nl, nm);
    addOpe(val, l, r, k*2+1, nm, nr);

    buf[k] = predFun(buf[k*2], buf[k*2+1]);
  }

  void opSliceOpAssign(string op: "+")(T val, size_t l, size_t r)
  {
    addOpe(val, l, r, 1, 0, an);
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
