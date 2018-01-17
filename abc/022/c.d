import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n, m; readV(n, m);

  auto gs = new int[](n), gr = GraphM!int(n-1).init;

  foreach (_; 0..m) {
    int u, v, l; readV(u, v, l); --u; --v;
    if (v == 0) swap(u, v);
    if (u == 0) {
      gs[v] = l;
    } else {
      gr[u-1][v-1] = gr[v-1][u-1] = l;
    }
  }

  int[] s;
  foreach (i; 1..n)
    if (gs[i]) s ~= i;
  auto ns = s.length;

  auto d = FloydWarshal!(typeof(gr)).floydWarshal(gr);

  auto r = int.max;
  foreach (i; 0..ns-1)
    foreach (j; i+1..ns) {
      auto si = s[i], sj = s[j];
      r = min(r, gs[si] + gs[sj] + d[si-1][sj-1]);
    }

  writeln(r >= gr.inf ? -1 : r);
}

struct GraphM(W = int, W i = 10^^9)
{
  import std.typecons;
  alias Wt = W, inf = i;
  int n;
  Wt[][] g;
  mixin Proxy!g;
  this(int n) { this.n = n; g = new Wt[][](n, n); }
  ref auto init() { foreach (i; 0..n) { g[i][] = inf; g[i][i] = 0; } return this; }
}

template FloydWarshal(Graph)
{
  import std.algorithm, std.array, std.traits;
  alias Wt = TemplateArgsOf!Graph[0];

  Wt[][] floydWarshal(Graph g)
  {
    Wt[][] dist;
    int[][] inter;
    floydWarshal(g, dist, inter);
    return dist;
  }

  void floydWarshal(Graph g, out Wt[][] dist, out int[][] inter)
  {
    auto n = g.n, sent = n;
    dist = g.g.map!(i => i.dup).array;

    inter = new int[][](n, n);
    foreach (i; 0..n) inter[i][] = sent;

    foreach (k; 0..n)
      foreach (i; 0..n)
        foreach (j; 0..n)
          if (dist[i][j] > dist[i][k] + dist[k][j]) {
            dist[i][j] = dist[i][k] + dist[k][j];
            inter[i][j] = k;
          }
  }
}
