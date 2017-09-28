import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!(long, size_t, 10L ^^ 18);
alias edge = graph.Edge;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1];

  auto g = new edge[][](n);
  foreach (_; 0..m){
    auto rd2 = readln.split, a = rd2[0].to!size_t-1, b = rd2[1].to!size_t-1, c = rd2[2].to!long;
    g[a] ~= edge(a, b, -c);
  }

  auto dist = graph.bellmanFord(g, 0), d = dist[n-1];
  if (d <= -graph.inf)
    writeln("inf");
  else
    writeln(-d);
}

template Graph(Wt, Node, Wt _inf = 10 ^^ 9, Node _sent = Node.max)
{
  const inf = _inf, sent = _sent;

  struct Edge
  {
    Node src, dst;
    Wt wt;
  }

  Wt[] bellmanFord(Edge[][] g, Node s)
  {
    Wt[] dist;
    Node[] prev;
    bellmanFord(g, s, dist, prev);
    return dist;
  }

  void bellmanFord(Edge[][] g, Node s, out Wt[] dist, out Node[] prev)
  {
    auto n = g.length;

    dist = new Wt[](n);
    dist[] = inf + inf;
    dist[s] = 0;

    prev = new Node[](n);
    prev[] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (e; g[i])
          if (dist[e.dst] > dist[e.src] + e.wt) {
            dist[e.dst] = dist[e.src] + e.wt;
            prev[e.dst] = e.src;
            if (k == n-1) dist[e.dst] = -inf;
          }
  }
}
