import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  auto tree = Tree(n);
  foreach (i; 0..n-1) {
    auto rd = readln.split.to!(size_t[]), a = rd[0], b = rd[1];
    tree.addEdge(a, b);
  }
  tree.rootify(0);

  auto u = new long[](n);
  foreach (i; 0..n)
    u[i] = readln.chomp.to!long;

  auto v = new long[](n), q = DList!size_t(0);
  while (!q.empty) {
    auto s = q.front; q.removeFront();
    foreach (t; tree.adj[s])
      if (t != tree.parent[s]) {
        v[t] = u[t] + v[s];
        q.insertBack(t);
      }
  }

  auto m = readln.chomp.to!size_t, r = 0L;
  foreach (i; 0..m) {
    auto rd = readln.split, a = rd[0].to!size_t, b = rd[1].to!size_t, c = rd[2].to!long;
    auto l = tree.lca(a, b);
    r += (v[a] + v[b] - 2 * v[l] + u[l]) * c;
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
