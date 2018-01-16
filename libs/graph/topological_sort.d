struct Graph(N = int, N i = 10^^9)
{
  import std.typecons;
  alias Node = N, inf = i;
  Node n;
  Node[][] g;
  mixin Proxy!g;
  this(Node n) { this.n = n; g = new Node[][](n); }
  void addEdge(Node u, Node v) { g[u] ~= v; }
  void addEdgeB(Node u, Node v) { g[u] ~= v; g[v] ~= u; }
}

auto topologicalSort(Graph)(Graph g)
{
  import std.container;
  alias Node = g.Node;
  auto n = cast(Node)(g.length), h = new int[](n);

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

unittest
{
  auto g = Graph!int(8);
  g[0] = [2];
  g[1] = [0, 4];
  g[2] = [3, 6];
  g[4] = [3, 5];
  g[5] = [6, 7];
  g[7] = [6];

  assert(topologicalSort(g) == [1,4,5,7,0,2,6,3]);
}
