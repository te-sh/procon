import graph;

auto stronglyConnectedComponents(Graph)(ref Graph g)
{
  import std.algorithm, std.container;

  alias Node = g.Node;
  auto n = g.n;

  auto rdj = Graph(n), visited = new bool[](n);
  foreach (u; 0..n)
    foreach (v; g[u])
      rdj.addEdge(v, u);

  auto dfs(Node s, Graph adj, ref bool[] visited)
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

  Node[] ord;
  Node[][] scc;

  foreach (u; 0..n)
    if (!visited[u]) ord ~= dfs(u, g, visited);

  visited[] = false;

  foreach_reverse (u; ord)
    if (!visited[u]) scc ~= dfs(u, rdj, visited);

  return scc;
}

unittest
{
  auto g = Graph!int(7);
  g.addEdge(0, 1);
  g.addEdge(1, 2);
  g.addEdge(2, 0);
  g.addEdge(2, 3);
  g.addEdge(3, 4);
  g.addEdge(4, 3);
  g.addEdge(4, 5);
  g.addEdge(4, 6);
  assert(g.stronglyConnectedComponents == [[1,2,0],[4,3],[6],[5]]);
}
