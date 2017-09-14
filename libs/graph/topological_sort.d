template Graph(Node)
{
  import std.container;

  Node[] topologicalSort(Node[][] g)
  {
    auto n = g.length, h = new size_t[](n);

    foreach (u; 0..n)
      foreach (v; g[u])
        ++h[v];

    auto st = SList!Node();
    foreach (i; 0..n)
      if (h[i] == 0) st.insertFront(i);

    Node[] ans;
    while (!st.empty()) {
      auto u = st.front; st.removeFront();
      ans ~= u;
      foreach (v; g[u]) {
        --h[v];
        if (h[v] == 0) st.insertFront(v);
      }
    }

    return ans;
  }
}

unittest
{
  alias graph = Graph!(size_t);

  auto g = new size_t[][](8);
  g[0] = [2];
  g[1] = [0, 4];
  g[2] = [3, 6];
  g[3] = [];
  g[4] = [3, 5];
  g[5] = [6, 7];
  g[6] = [];
  g[7] = [6];

  assert(graph.topologicalSort(g) == [1,4,5,7,0,2,6,3]);
}
