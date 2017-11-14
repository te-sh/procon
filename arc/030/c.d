import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1], k = rd[2];
  auto c = readln.split;

  auto scc = StronglyConnectedComponents!int(n);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1;
    scc.addEdge(a, b);
  }

  auto r = scc.run(), nr = r.length.to!int, s = new string[](nr);

  int[int] buf;
  foreach (int i, ri; r) {
    char[] sb;
    foreach (rij; ri) {
      buf[rij] = i;
      sb ~= c[rij][0];
    }
    (cast(ubyte[])sb).sort();
    s[i] = sb.to!string;
  }

  auto g = new int[][](nr);
  foreach (u; 0..n)
    foreach (v; scc.adj[u])
      if (buf[u] != buf[v])
        g[buf[u]] ~= buf[v];

  auto d = new int[](nr), dp = new string[][](nr, n+1);
  foreach_reverse (u; 0..nr) {
    foreach (v; g[u]) d[u] = max(d[u], d[v]);
    d[u] += s[u].length.to!int;

    foreach (i; 0..s[u].length+1)
      dp[u][i] = s[u][0..i];
    dp[u][s[u].length+1..$] = "|";

    foreach (i; 0..s[u].length+1) {
      foreach (v; g[u])
        foreach (j; 0..d[v]+1)
          dp[u][i+j] = min(dp[u][i+j], s[u][0..i] ~ dp[v][j]);
    }
  }

  auto ans = "|";
  foreach (i; 0..nr)
    if (d[i] >= k)
      ans = min(ans, dp[i][k]);

  writeln(ans == "|" ? "-1" : ans);
}

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
