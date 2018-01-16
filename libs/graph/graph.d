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
