import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(int[]), n = rd1[0], m = rd1[1];
  auto g = new int[][](n);
  foreach (_; 0..m) {
    auto rd2 = readln.splitter;
    auto x = rd2.front.to!int-1; rd2.popFront();
    auto y = rd2.front.to!int-1;
    g[x] ~= y;
    g[y] ~= x;
  }

  auto bccSt = BiconnectedComponent!int(g);
  bccSt.run();

  auto ec = new int[](n), nt = bccSt.bccs.length.to!int;
  foreach (int i, bcc; bccSt.bccs)
    foreach (c; bcc) ec[c] = i;

  auto t = Tree!int(nt);
  foreach (b; bccSt.brdg) {
    auto u = ec[b.u], v = ec[b.v];
    t.addEdge(u, v);
  }
  t.rootify(0);

  auto dist(int x, int y)
  {
    auto z = t.lca(x, y);
    return t.depth[x] + t.depth[y] - t.depth[z] * 2;
  }

  auto q = readln.chomp.to!int;
  foreach (_; 0..q) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!int-1; rd2.popFront();

    a = ec[a]; b = ec[b]; c = ec[c];

    if (dist(a, b) + dist(b, c) == dist(a, c))
      writeln("OK");
    else
      writeln("NG");
  }
}

struct BiconnectedComponent(Node)
{
  import std.algorithm, std.container, std.conv;

  Node n, sent;
  Node[][] g;

  Node[] ord;
  bool[] inS;
  SList!Node roots, S;

  struct Edge { Node u, v; }
  Edge[] brdg;
  Node[][] bccs;

  int k;

  this(Node[][] g)
  {
    this.g = g;
    n = g.length.to!Node;
    sent = n;

    ord = new Node[](n);
    inS = new bool[](n);

    roots = SList!Node();
    S = SList!Node();
  }

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

  auto run()
  {
    foreach (i; 0..n)
      if (!ord[i])
        visit(i, sent);
  }
}

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
