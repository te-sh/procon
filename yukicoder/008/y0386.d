import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);

  auto g = Graph!int(n);
  foreach (i; 0..n-1) {
    int a, b; readV(a, b);
    g.addEdgeB(a, b);
  }
  auto tree = makeTree(g).rootify(0).doubling;

  auto u = readArrayM!long(n);

  auto v = new long[](n), q = DList!size_t(0);
  while (!q.empty) {
    auto s = q.front; q.removeFront();
    foreach (t; tree[s].filter!(t => t != tree.parent[s])) {
      v[t] = u[t] + v[s];
      q.insertBack(t);
    }
  }

  int m; readV(m);
  auto r = 0L;
  foreach (i; 0..m) {
    int a, b; long c; readV(a, b, c);
    auto l = tree.lca(a, b);
    r += (v[a] + v[b] - 2 * v[l] + u[l]) * c;
  }

  writeln(r);
}

struct Graph(N = int)
{
  alias Node = N;
  Node n;
  Node[][] g;
  alias g this;
  this(Node n) { this.n = n; g = new Node[][](n); }
  void addEdge(Node u, Node v) { g[u] ~= v; }
  void addEdgeB(Node u, Node v) { g[u] ~= v; g[v] ~= u; }
}

struct Tree(Graph)
{
  import std.algorithm, std.container;
  alias Node = Graph.Node;
  Graph g;
  alias g this;
  Node root;
  Node[] parent;
  int[] size, depth;

  this(ref Graph g) { this.g = g; this.n = g.n; }

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

ref auto makeTree(Graph)(ref Graph g) { return Tree!Graph(g); }

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
