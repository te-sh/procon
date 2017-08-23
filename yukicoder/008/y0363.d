import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto a = new int[](n), rd1 = readln.chomp.splitter(' ');
  foreach (i; 0..n) {
    a[i] = rd1.front.to!int;
    rd1.popFront();
  }

  auto isKadomatsu(size_t i1, size_t i2, size_t i3)
  {
    auto v1 = a[i1], v2 = a[i2], v3 = a[i3];
    return v1 != v2 && v2 != v3 && v3 != v1 && (v1 > v2 && v3 > v2 || v1 < v2 && v3 < v2);
  }

  auto tree = Tree(n);

  foreach (_; 0..n-1) {
    auto rd2 = readln.chomp.splitter(' ');
    auto u = rd2.front.to!size_t-1;
    rd2.popFront();
    auto v = rd2.front.to!size_t-1;
    tree.addEdge(u, v);
  }

  tree.rootify(0);
  tree.makePath(0);

  auto pathKadomatsu = new SparseTable!(bool, "a & b")[](tree.paths.length);
  foreach (i, path; tree.paths) {
    auto pl = path.length;
    if (pl >= 3) {
      auto b = new bool[](pl-2);
      foreach (j; 0..pl-2)
        b[j] = isKadomatsu(path[j], path[j+1], path[j+2]);
      pathKadomatsu[i] = SparseTable!(bool, "a & b")(b);
    }
  }

  struct AKR { bool r; size_t uchild; }

  auto allKadomatsu(size_t u, size_t v)
  {
    size_t head;

    while (tree.path[u] != tree.path[v]) {
      auto pathNo = tree.path[v], path = tree.paths[pathNo];
      auto d = tree.depthInPath(v);

      head = path[0];
      auto headParent = tree.parent[head];

      if (d >= 2 && !pathKadomatsu[pathNo][0..d-1] ||
          path.length >= 2 && d >= 1 && !isKadomatsu(headParent, head, path[1]) ||
          headParent != u && !isKadomatsu(tree.parent[headParent], headParent, head)) {
        return AKR(false, 0);
      }

      v = headParent;
    }

    auto pathNo = tree.path[v], path = tree.paths[pathNo];
    auto d1 = tree.depthInPath(u), d2 = tree.depthInPath(v);
    if (d2 - d1 >= 2 && !pathKadomatsu[pathNo][d1..d2-1])
      return AKR(false, 0);

    return AKR(true, u == v ? head : path[d1+1]);
  }

  auto calc(size_t u, size_t v)
  {
    auto lca = tree.lca(u, v);
    if (lca == v) swap(u, v);

    if (tree.parent[v] == u) return false;

    if (lca == u) {
      auto r = allKadomatsu(u, v);

      if (!r.r ||
          !isKadomatsu(tree.parent[v], v, u) ||
          !isKadomatsu(v, u, r.uchild))
        return false;

      return true;
    } else {
      auto r1 = allKadomatsu(lca, u);
      auto r2 = allKadomatsu(lca, v);

      if (!r1.r || !r2.r ||
          !isKadomatsu(r1.uchild, lca, r2.uchild) ||
          !isKadomatsu(tree.parent[u], u, v) ||
          !isKadomatsu(u, v, tree.parent[v]))
        return false;

      return true;
    }
  }

  auto q = readln.chomp.to!size_t;
  foreach (_; 0..q) {
    auto rd3 = readln.chomp.splitter;
    auto u = rd3.front.to!size_t-1;
    rd3.popFront();
    auto v = rd3.front.to!size_t-1;
    writeln(calc(u, v) ? "YES" : "NO");
  }
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

struct SparseTable(T, alias pred = "a < b ? a : b")
{
  import std.algorithm, std.functional;
  alias predFun = binaryFun!pred;

  size_t[] logTable;
  size_t[][] rmq;
  size_t n;
  T[] a;

  this(T[] a)
  {
    this.a = a;
    this.n = a.length;

    logTable = new size_t[n + 1];
    foreach (i; 2..n+1)
      logTable[i] = logTable[i >> 1] + 1;

    rmq = new size_t[][](logTable[n] + 1, n);

    foreach (i; 0..n)
      rmq[0][i] = i;

    for (size_t k = 1; (1 << k) < n; ++k)
      for (size_t i = 0; i + (1 << k) <= n; ++i) {
        auto x = rmq[k - 1][i];
        auto y = rmq[k - 1][i + (1 << k - 1)];
        rmq[k][i] = predFun(a[x], a[y]) == a[x] ? x : y;
      }
  }

  pure size_t opDollar() const { return n; }

  pure T opSlice(size_t l, size_t r) const
  {
    auto k = logTable[r - l - 1];
    auto x = rmq[k][l];
    auto y = rmq[k][r - (1 << k)];
    return predFun(a[x], a[y]);
  }
}
