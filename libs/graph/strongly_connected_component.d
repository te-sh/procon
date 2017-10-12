struct StronglyConnectedComponents(Node)
{
  import std.algorithm, std.container;

  Node n;
  Node[][] adj, rdj;

  this(Node n)
  {
    this.n = n;
    adj = new Node[][](n);
    rdj = new Node[][](n);
  }

  auto addEdge(Node src, Node dst)
  {
    adj[src] ~= dst;
    rdj[dst] ~= src;
  }

  auto dfs(Node s, Node[][] adj, ref bool[] visited)
  {
    auto q = SList!Node(s);
    visited[s] = true;
    Node[] comp;
    while (!q.empty) {
      auto u = q.front; q.removeFront();
      foreach (v; adj[u])
        if (!visited[v]) {
          visited[v] = true;
          q.insertFront(v);
        }
      comp ~= u;
    }
    comp.reverse();
    return comp;
  }

  auto run()
  {
    Node[] ord;
    Node[][] scc;
    auto visited = new bool[](n);

    foreach (u; 0..n)
      if (!visited[u]) ord ~= dfs(u, adj, visited);

    visited[] = false;

    foreach_reverse (u; ord)
      if (!visited[u]) scc ~= dfs(u, rdj, visited);

    return scc;
  }
}

unittest
{
  auto scc = StronglyConnectedComponents!size_t(7);
  scc.addEdge(0, 1);
  scc.addEdge(1, 2);
  scc.addEdge(2, 0);
  scc.addEdge(2, 3);
  scc.addEdge(3, 4);
  scc.addEdge(4, 3);
  scc.addEdge(4, 5);
  scc.addEdge(4, 6);
  assert(scc.run == [[1,2,0],[4,3],[6],[5]]);
}
