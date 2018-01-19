import graph, tree;

struct Doubling(Tree)
{
  import std.algorithm, std.container, core.bitop;
  alias Node = Tree.Node;
  Tree t;
  alias t this;
  Node[][] ans;
  int log2md;

  this(ref Tree t)
  {
    this.t = t;
    auto n = t.n, sent = n, md = maxDepth(n);
    log2md = md == 0 ? 1 : md.bsr+1;
    ans = new Node[][](n, log2md);
    foreach (i; 0..n) {
      ans[i][0] = t.parent[i];
      ans[i][1..$] = sent;
    }

    auto q = SList!Node(t.root);
    while (!q.empty) {
      auto u = q.front; q.removeFront();
      foreach (i; 1..log2md) {
        auto v = ans[u][i-1];
        if (v == sent) break;
        ans[u][i] = ans[v][i-1];
      }
      foreach (v; t[u].filter!(v => v != t.parent[u]))
        q.insertFront(v);
    }
  }

  auto maxDepth(Node n)
  {
    auto m = 0;
    foreach (i; 0..n) m = max(m, t.depth[i]);
    return m;
  }

  auto ancestor(Node u, int k)
  {
    for (auto i = 0; k > 0; k >>= 1, ++i)
      if (k&1) u = ans[u][i];
    return u;
  }

  auto lca(Node u, Node v)
  {
    if (t.depth[u] > t.depth[v]) swap(u, v);
    if (u == t.root) return u;
    v = ancestor(v, t.depth[v]-t.depth[u]);
    if (u == v) return u;

    foreach_reverse (i; 0..log2md)
      if (ans[u][i] != ans[v][i]) {
        u = ans[u][i];
        v = ans[v][i];
      }

    return t.parent[u];
  }
}

auto doubling(Tree)(ref Tree t) { return Doubling!Tree(t); }

unittest
{
  auto g = Graph!int(13);

  g.addEdgeB(0, 1);
  g.addEdgeB(0, 2);
  g.addEdgeB(1, 3);
  g.addEdgeB(1, 4);
  g.addEdgeB(1, 5);
  g.addEdgeB(2, 6);
  g.addEdgeB(4, 7);
  g.addEdgeB(4, 8);
  g.addEdgeB(6, 10);
  g.addEdgeB(6, 11);
  g.addEdgeB(11, 12);
  g.addEdgeB(8, 9);

  auto tree = makeTree(g).rootify(0);
  auto db = doubling(tree);

  assert(db.lca(1, 3) == 1);
  assert(db.lca(2, 3) == 0);
  assert(db.lca(1, 8) == 1);
  assert(db.lca(7, 9) == 4);
}
