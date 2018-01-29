import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

void main()
{
  int n, m, q; readV(n, m, q);
  auto a = new int[](m), b = new int[](m);
  foreach (i; 0..m) {
    readV(a[i], b[i]); --a[i]; --b[i];
  }

  auto g = Graph!int(n);
  foreach (i; 0..m) g.addEdgeB(a[i], b[i]);
  auto rbc = biconnectedComponents(g), nt = rbc.bccs.length.to!int;
  auto tv = new int[](n);
  foreach (int i, bcc; rbc.bccs)
    foreach (v; bcc) tv[v] = i;

  auto gt = Graph!int(nt);
  foreach (brdg; rbc.brdg) gt.addEdgeB(tv[brdg.u], tv[brdg.v]);
  auto tr = makeTree(gt).rootify(0).hlDecomposition;
  tr.makePath(0);
  auto np = tr.paths.length.to!int;

  auto bh = new BinaryHeap!(Array!int, "a<b")[](nt);
  foreach (i; 0..nt) bh[i] = heapify!"a<b"(Array!int());
  int[int] wv;
  auto st = new SegmentTree!(int, max)*[](np);
  foreach (i; 0..np) st[i] = new SegmentTree!(int, max)(tr.paths[i].length);

  auto calc(int u, int v)
  {
    auto m = 0;
    while (tr.path[u] != tr.path[v]) {
      m = max(m, (*st[tr.path[u]])[0..tr.depthInPath(u)+1]);
      u = tr.parent[tr.head[u]];
    }
    return max(m, (*st[tr.path[u]])[tr.depthInPath(v)..tr.depthInPath(u)+1]);
  }

  foreach (_; 0..q) {
    int c, s, t; readV(c, s, t);
    switch (c) {
    case 1:
      s = tv[s-1];
      wv[t] = s;
      auto cw = (*st[tr.path[s]])[tr.depthInPath(s)];
      if (cw > 0) {
        if (t > cw) {
          (*st[tr.path[s]])[tr.depthInPath(s)] = t;
          bh[s].insert(cw);
        } else {
          bh[s].insert(t);
        }
      } else {
        (*st[tr.path[s]])[tr.depthInPath(s)] = t;
      }
      break;
    case 2:
      s = tv[s-1]; t = tv[t-1];
      auto lca = tr.lca(s, t), wm = 0;
      wm = max(calc(s, lca), calc(t, lca));
      if (wm > 0) {
        writeln(wm);
        auto v = wv[wm];
        (*st[tr.path[v]])[tr.depthInPath(v)] = 0;
        if (!bh[v].empty) {
          (*st[tr.path[v]])[tr.depthInPath(v)] = bh[v].front;
          bh[v].removeFront;
        }
      } else {
        writeln(-1);
      }
      break;
    default:
      assert(0);
    }
  }
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

ref auto biconnectedComponents(Graph)(ref Graph g)
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

struct HlDecomposition(Tree)
{
  import std.container;
  alias Node = Tree.Node;
  Tree t;
  alias t this;
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
ref auto hlDecomposition(Tree)(ref Tree t) { return HlDecomposition!(Tree)(t); }

struct SegmentTree(T, alias pred = "a + b")
{
  import core.bitop, std.functional;
  alias predFun = binaryFun!pred;

  const size_t n, an;
  T[] buf;
  T unit;

  this(size_t n, T unit = T.init)
  {
    this.n = n;
    this.unit = unit;
    an = n == 1 ? 1 : (1 << ((n-1).bsr + 1));
    buf = new T[](an*2);
    if (T.init != unit) buf[] = unit;
  }

  this(T[] init, T unit = T.init)
  {
    this(init.length, unit);
    buf[an..an+n][] = init[];
    foreach_reverse (i; 1..an)
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
  }

  void opIndexAssign(T val, size_t i)
  {
    buf[i += an] = val;
    while (i /= 2)
      buf[i] = predFun(buf[i*2], buf[i*2+1]);
  }

  pure T opSlice(size_t l, size_t r)
  {
    l += an; r += an;
    T r1 = unit, r2 = unit;
    while (l != r) {
      if (l % 2) r1 = predFun(r1, buf[l++]);
      if (r % 2) r2 = predFun(buf[--r], r2);
      l /= 2; r /= 2;
    }
    return predFun(r1, r2);
  }

  pure T opIndex(size_t i) { return buf[i+an]; }
  pure size_t opDollar() { return n; }
}
