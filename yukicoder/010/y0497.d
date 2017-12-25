import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!int;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!int;
  auto s = new int[][](n, 3);
  foreach (i; 0..n) {
    s[i] = readln.split.to!(int[]);
    s[i].sort();
  }

  auto g = new int[][](n);
  foreach (i; 0..n)
    foreach (j; 0..n)
      if (iota(3).all!(k => s[i][k] > s[j][k])) g[i] ~= j;

  auto ts = graph.topologicalSort(g);

  auto dp = new int[](n);
  dp[] = 1;

  foreach_reverse (i; ts)
    foreach (j; g[i])
      dp[i] = max(dp[i], dp[j]+1);

  writeln(dp.maxElement);
}

template Graph(Node)
{
  import std.container;

  Node[] topologicalSort(Node[][] g)
  {
    auto n = cast(Node)(g.length), h = new size_t[](n);

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
