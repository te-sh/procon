struct Tree(Node)
{
  import std.container;

  Node n;
  Node[][] adj;
  int[] size, depth;
  Node[] head, parent, path;
  Node[][] paths;

  this(Node n)
  {
    this.n = n;
    adj = new Node[][](n);
  }

  auto addEdge(Node s, Node t)
  {
    adj[s] ~= t;
    adj[t] ~= s;
  }

  auto rootify(Node r)
  {
    parent = new Node[](n);
    depth = new int[](n);
    depth[] = -1;

    struct UP { Node u, p; }
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

    head = new Node[](n);
    head[] = n;

    struct US { Node u, s; }
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

  auto makePath(Node r)
  {
    auto pathIndex = 0;
    path = new Node[](n);

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

unittest
{
  auto tree = Tree!size_t(13);

  tree.addEdge(0, 1);
  tree.addEdge(0, 2);
  tree.addEdge(1, 3);
  tree.addEdge(1, 4);
  tree.addEdge(1, 5);
  tree.addEdge(2, 6);
  tree.addEdge(4, 7);
  tree.addEdge(4, 8);
  tree.addEdge(6, 10);
  tree.addEdge(6, 11);
  tree.addEdge(11, 12);
  tree.addEdge(8, 9);

  tree.rootify(0);

  assert(tree.lca(1, 3) == 1);
  assert(tree.lca(2, 3) == 0);
  assert(tree.lca(1, 8) == 1);
  assert(tree.lca(7, 9) == 4);

  tree.makePath(0);
  assert(tree.paths[0] == [0,1,4,8,9]);
  assert(tree.path[2] == 1);
}
