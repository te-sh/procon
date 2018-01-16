import graph;

struct Tree(Graph)
{
  import std.algorithm, std.container, std.typecons;

  Graph g;
  mixin Proxy!g;
  alias Node = g.Node;
  Node root;
  Node[] parent;
  int[] size, depth;

  this(Graph g) { this.g = g; this.n = g.n; }

  ref auto rootify(Node r)
  {
    this.root = r;

    parent = new Node[](g.n);
    depth = new int[](g.n);
    depth[] = -1;

    struct UP { Node u, p; }
    auto st1 = SList!UP(UP(r, r));
    auto st2 = SList!UP();
    while (!st1.empty) {
      auto up = st1.front, u = up.u, p = up.p; st1.removeFront();

      parent[u] = p;
      depth[u] = depth[p] + 1;

      foreach (v; g[u])
        if (v != p) {
          st1.insertFront(UP(v, u));
          st2.insertFront(UP(v, u));
        }
    }

    size = new int[](g.n);
    size[] = 1;

    while (!st2.empty) {
      auto up = st2.front, u = up.u, p = up.p; st2.removeFront();
      size[p] += size[u];
    }

    return this;
  }

  auto children(Node u) { return g[u].filter!(v => v != parent[u]); }
}

ref auto makeTree(Graph)(Graph g) { return Tree!Graph(g); }

unittest
{
  import std.algorithm;

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

  assert(tree.parent[0] == 0);
  assert(tree.parent[1] == 0);
  assert(tree.parent[3] == 1);

  assert(tree.depth[0] == 0);
  assert(tree.depth[1] == 1);
  assert(tree.depth[3] == 2);

  assert(equal(tree.children(0), [1, 2]));
  assert(equal(tree.children(1), [3, 4, 5]));
}
