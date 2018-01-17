import graph;

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

unittest
{
  auto g = Graph!int(10);
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

  auto r = g.biconnectedComponents;

  assert(r.brdg[0].u == 7 && r.brdg[0].v == 8);
  assert(r.brdg[1].u == 7 && r.brdg[1].v == 9);
  assert(r.brdg[2].u == 3 && r.brdg[2].v == 5);
  assert(r.brdg[3].u == 0 && r.brdg[3].v == 1);

  assert(r.bccs[0] == [8]);
  assert(r.bccs[1] == [9]);
  assert(r.bccs[2] == [7, 6, 5]);
  assert(r.bccs[3] == [3, 4, 2, 1]);
  assert(r.bccs[4] == [0]);
}
