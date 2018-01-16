import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n, m; readV(n, m);
  auto g = Graph!int(n);
  foreach (_; 0..m) {
    int x, y; readV(x, y); --x; --y;
    g.addEdgeB(x, y);
  }

  auto r = g.biconnectedComponents;

  auto ec = new int[](n), nt = r.bccs.length.to!int;
  foreach (int i, bcc; r.bccs)
    foreach (c; bcc) ec[c] = i;

  auto gt = Graph!int(nt);
  foreach (b; r.brdg) {
    auto u = ec[b.u], v = ec[b.v];
    gt.addEdgeB(u, v);
  }
  auto t = makeTree(gt).rootify(0).hlDecomposition;

  auto dist(int x, int y)
  {
    auto z = t.lca(x, y);
    return t.depth[x] + t.depth[y] - t.depth[z] * 2;
  }

  auto q = readln.chomp.to!int;
  foreach (_; 0..q) {
    int a, b, c; readV(a, b, c); --a; --b; --c;
    a = ec[a]; b = ec[b]; c = ec[c];

    if (dist(a, b) + dist(b, c) == dist(a, c))
      writeln("OK");
    else
      writeln("NG");
  }
}

struct Graph(N = int)
{
  import std.typecons;
  alias Node = N;
  Node n;
  Node[][] g;
  mixin Proxy!g;
  this(Node n) { this.n = n; g = new Node[][](n); }
  void addEdge(Node u, Node v) { g[u] ~= v; }
  void addEdgeB(Node u, Node v) { g[u] ~= v; g[v] ~= u; }
}

ref auto biconnectedComponents(Graph)(Graph g)
{
  import std.algorithm, std.container, std.typecons;

  alias Node = g.Node;
  auto n = g.n, sent = g.n, ord = new Node[](n), inS = new bool[](n);
  auto roots = SList!Node(), S = SList!Node();

  struct Edge { Node u, v; }
  Edge[] brdg;
  Node[][] bccs;

  int k;

  void visit(Node cur, Node prev)
  {
    ord[cur] = ++k;
    S.insertFront(cur);
    inS[cur] = true;
    roots.insertFront(cur);

    foreach (v; g[cur]) {
      if (!ord[v])
        visit(v, cur);
      else if (v != prev && inS[v])
        while (ord[roots.front] > ord[v]) roots.removeFront();
    }

    if (cur == roots.front) {
      if (prev != sent)
        brdg ~= Edge(prev, cur);
      Node[] bcc;
      for (;;) {
        auto node = S.front; S.removeFront();
        inS[node] = false;
        bcc ~= node;
        if (node == cur) break;
      }
      bccs ~= bcc;
      roots.removeFront();
    }
  }

  foreach (i; 0..n)
    if (!ord[i]) visit(i, sent);

  return tuple!("bccs", "brdg")(bccs, brdg);
}

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
}

ref auto makeTree(Graph)(Graph g) { return Tree!Graph(g); }

struct HlDecomposition(Tree, Node)
{
  import std.container, std.typecons;

  Tree t;
  mixin Proxy!t;
  Node[] head, path;
  Node[][] paths;

  this(Tree t)
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
