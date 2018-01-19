import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n, q; readV(n, q);
  auto g = Graph!int(n);
  foreach (i; 0..n-1) {
    int a, b; readV(a, b); --a; --b;
    g.addEdgeB(a, b);
  }

  auto e = new int[](n), visited = new bool[](n);

  auto qu = DList!int(), ta = readln.chomp;
  foreach (i; 0..n)
    if (ta[i] == '1') {
      visited[i] = true;
      qu.insertBack(i);
    }

  while (!qu.empty) {
    auto u = qu.front; qu.removeFront();
    foreach (v; g[u].filter!(v => !visited[v])) {
      e[v] = e[u]+1;
      visited[v] = true;
      qu.insertBack(v);
    }
  }

  auto tr = makeTree(g).rootify(0).doubling;

  auto x1 = new int[](n), x2 = new int[](n);
  foreach (i; 0..n) {
    x1[i] = e[i]*3-tr.depth[i];
    x2[i] = e[i]*3+tr.depth[i];
    
  }

  auto y1 = new int[][](n, tr.log2md), y2 = new int[][](n, tr.log2md);
  foreach (i; 0..n) {
    y1[i][0] = min(x1[i], x1[tr.parent[i]]);
    y2[i][0] = min(x2[i], x2[tr.parent[i]]);
  }

  qu.insertBack(tr.root);
  while (!qu.empty) {
    auto u = qu.front; qu.removeFront();
    foreach (i; 1..tr.log2md) {
      auto v = tr.ans[u][i-1];
      if (v == tr.sent) break;
      y1[u][i] = min(y1[u][i-1], y1[v][i-1]);
      y2[u][i] = min(y2[u][i-1], y2[v][i-1]);
    }
  }

  auto calcMinY1(int u, int k)
  {
    int r = x1[u];
    for (auto i = 0; k > 0; k >>= 1, ++i)
      if (k&1) {
        r = min(r, y1[u][i]);
        u = tr.ans[u][i];
      }
    return r;
  }

  auto calcMinY2(int u, int k)
  {
    int r = x2[u];
    for (auto i = 0; k > 0; k >>= 1, ++i)
      if (k&1) {
        r = min(r, y2[u][i]);
        u = tr.ans[u][i];
      }
    return r;
  }

  foreach (_; 0..q) {
    int s, t; readV(s, t); --s; --t;
    auto lca = tr.lca(s, t);

    auto r1 = (tr.depth[s]+tr.depth[t]-tr.depth[lca])*2;
    auto r2 = calcMinY1(s, tr.depth[s]-tr.depth[lca])+
      tr.depth[s]*2+tr.depth[t]-tr.depth[lca];
    auto r3 = calcMinY2(t, tr.depth[t]-tr.depth[lca])+
      tr.depth[s]*2+tr.depth[t]-tr.depth[lca]*2;

    writeln(min(r1, r2, r3));
  }
}

struct Graph(N = int)
{
  import std.typecons;
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
  import std.algorithm, std.container, std.typecons;

  Graph g;
  alias Node = g.Node;
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

ref auto makeTree(Graph)(Graph g) { return Tree!Graph(g); }

struct Doubling(Tree)
{
  import std.algorithm, std.container, std.typecons, std.traits, core.bitop;

  Tree t;
  alias Node = t.g.Node;
  alias t this;
  Node[][] ans;
  Node sent;
  int log2md;

  this(ref Tree t)
  {
    this.t = t;
    auto n = t.n, md = maxDepth(n);
    sent = n;
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

auto doubling(Tree)(Tree t) { return Doubling!Tree(t); }
