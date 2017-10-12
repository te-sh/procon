import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.math;      // math functions

const offset = 10 ^^ 9, blocks = 100, blockSize = 2 * 10 ^^ 8;

version(unittest) {} else
void main()
{
  int[] fx, fy, sx, sy;
  auto n = readln.chomp.to!int;
  loadPoints(n, fx, fy);
  auto m = readln.chomp.to!int;
  loadPoints(m, sx, sy);

  auto b = new int[][][](blocks, blocks);
  foreach (i; 0..m) {
    auto ibx = idx(sx[i]), iby = idx(sy[i]);
    b[iby][ibx] ~= i;
  }

  auto scc = StronglyConnectedComponents!int(n);
  foreach (i; 0..n) {
    auto minS = ulong.max;
    if (m <= 5000) {
      foreach (j; 0..m)
        minS = min(minS, dist(fx[i], fy[i], sx[j], sy[j]));
    } else {
      auto ibfx = idx(fx[i]), ibfy = idx(fy[i]);
      foreach (ibsy; max(0, ibfy-1)..min(blocks, ibfy+2))
        foreach (ibsx; max(0, ibfx-1)..min(blocks, ibfx+2))
          foreach (bi; b[ibsy][ibsx])
            minS = min(minS, dist(fx[i], fy[i], sx[bi], sy[bi]));
    }

    foreach (j; 0..n)
      if (i != j) {
        auto d = dist(fx[i], fy[i], fx[j], fy[j]);
        if (d < minS) scc.addEdge(i, j);
      }
  }

  auto c = scc.run(), ans = 0, visited = new bool[](n);
  foreach (ci; c) {
    auto t = ci[0];
    if (!visited[t]) {
      visited[t] = true;
      auto q = SList!size_t(t);
      while (!q.empty) {
        auto u = q.front; q.removeFront();
        foreach (v; scc.adj[u]) {
          if (!visited[v]) {
            visited[v] = true;
            q.insertFront(v);
          }
        }
      }
      ++ans;
    }
  }

  writeln(ans);
}

auto loadPoints(size_t n, ref int[] x, ref int[] y)
{
  x = new int[](n);
  y = new int[](n);
  foreach (i; 0..n) {
    auto rd = readln.splitter;
    x[i] = rd.front.to!int + offset; rd.popFront();
    y[i] = rd.front.to!int + offset;
  }
}

auto idx(int p)
{
  return (p - 1) / blockSize;
}

auto dist(int x1, int y1, int x2, int y2)
{
  return (x2-x1).abs.to!ulong ^^ 2 + (y2-y1).abs.to!ulong ^^ 2;
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
