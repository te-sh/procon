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

unittest
{
  auto g = new int[][](10);
  g[0] = [1];
  g[1] = [0, 2, 3];
  g[2] = [1, 4];
  g[3] = [1, 4, 5];
  g[4] = [2, 3];
  g[5] = [6, 7];
  g[6] = [5, 7];
  g[7] = [5, 8, 9];
  g[8] = [7];
  g[9] = [7];

  auto bcc = BiconnectedComponent!int(g);
  bcc.run();

  assert(bcc.brdg[0].u == 7 && bcc.brdg[0].v == 8);
  assert(bcc.brdg[1].u == 7 && bcc.brdg[1].v == 9);
  assert(bcc.brdg[2].u == 3 && bcc.brdg[2].v == 5);
  assert(bcc.brdg[3].u == 0 && bcc.brdg[3].v == 1);

  assert(bcc.bccs[0] == [8]);
  assert(bcc.bccs[1] == [9]);
  assert(bcc.bccs[2] == [7, 6, 5]);
  assert(bcc.bccs[3] == [3, 4, 2, 1]);
  assert(bcc.bccs[4] == [0]);
}
