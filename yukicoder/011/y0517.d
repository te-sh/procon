import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; readV(n);
  auto a = readArrayM!string(n);
  int m; readV(m);
  auto b = readArrayM!string(m);

  auto t = a.map!(ai => ai.length.to!int).sum;
  auto c = new char[](t), i = 0;
  int[char] d;
  foreach (ai; a)
    foreach (aij; ai) {
      d[aij] = i;
      c[i++] = aij;
    }

  auto g = Graph!int(t);

  foreach (ai; a)
    foreach (j; 0..ai.length-1)
      g.addEdge(d[ai[j]], d[ai[j+1]]);
  foreach (bi; b)
    foreach (j; 0..bi.length-1)
      g.addEdge(d[bi[j]], d[bi[j+1]]);

  if (g.count!(gi => gi.empty) > 1) {
    writeln(-1);
    return;
  }

  auto ts = g.topologicalSort;
  foreach (ti; ts) write(c[ti]);
  writeln;
}

struct Graph(N = int)
{
  alias Node = N;
  Node n;
  Node[][] g;
  alias g this;
  this(Node n) { this.n = n; g = new Node[][](n); }
  void addEdge(Node u, Node v) { g[u] ~= v; }
  void addEdgeB(Node u, Node v) { g[u] ~= v; g[v] ~= u; }
}

auto topologicalSort(Graph)(ref Graph g)
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
