import graph, tree;

struct HlDecomposition(Tree, Node)
{
  import std.container, std.typecons;

  Tree t;
  mixin Proxy!t;
  Node[] head, path;
  Node[][] paths;

  this(ref Tree t)
  {
    this.t = t;
    auto n = t.n;
    head = new Node[](n); head[] = n;

    struct US { Node u, s; }
    auto st = SList!US(US(t.root, t.root));

    while (!st.empty) {
      auto us = st.front, u = us.u, s = us.s; st.removeFront();

      head[u] = s;
      auto z = n;
      foreach (v; t[u])
        if (head[v] == n && (z == n || t.size[z] < t.size[v])) z = v;

      foreach (v; t[u])
        if (head[v] == n) st.insertFront(US(v, v == z ? s : v));
    }
  }

  auto makePath(Node r)
  {
    auto pathIndex = 0;
    path = new Node[](t.n);

    auto q = DList!Node(r);

    while (!q.empty) {
      auto u = q.front; q.removeFront();

      if (u == head[u]) {
        path[u] = pathIndex++;
        paths ~= [u];
      } else {
        path[u] = path[head[u]];
        paths[path[u]] ~= u;
      }

      foreach (v; t[u])
        if (v != t.parent[u]) q.insertBack(v);
    }
  }

  auto depthInPath(Node n)
  {
    return t.depth[n] - t.depth[head[n]];
  }

  auto lca(Node u, Node v)
  {
    while (head[u] != head[v])
      if (t.depth[head[u]] < t.depth[head[v]]) v = t.parent[head[v]];
      else                                     u = t.parent[head[u]];
    return t.depth[u] < t.depth[v] ? u : v;
  }
}

ref auto hlDecomposition(Tree)(Tree t) { return HlDecomposition!(Tree, t.Node)(t); }

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
  auto hd = hlDecomposition(tree);

  assert(hd.lca(1, 3) == 1);
  assert(hd.lca(2, 3) == 0);
  assert(hd.lca(1, 8) == 1);
  assert(hd.lca(7, 9) == 4);

  hd.makePath(0);
  assert(hd.paths[0] == [0,1,4,8,9]);
  assert(hd.path[2] == 1);
}
