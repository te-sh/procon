import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias graph = Graph!int;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];

  struct Edge { int a, b, c; }
  auto e = new Edge[](m);
  foreach (i; 0..m) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int; rd2.popFront();
    auto b = rd2.front.to!int; rd2.popFront();
    auto c = rd2.front.to!int;
    e[i] = Edge(a, b, c);
  }

  auto g = new int[][](n), fg = new Edge[][](n), rg = new Edge[][](n);
  foreach (ei; e) {
    g[ei.a] ~= ei.b;
    fg[ei.a] ~= ei;
    rg[ei.b] ~= ei;
  }

  auto t = graph.topologicalSort(g);

  auto fct = new int[](n), lct = new int[](n);
  foreach (ti; t[1..$])
    fct[ti] = rg[ti].map!(ej => fct[ej.a] + ej.c).maxElement;

  lct[n-1] = fct[n-1];
  foreach_reverse (ti; t[0..$-1])
    lct[ti] = fg[ti].map!(ej => lct[ej.b] - ej.c).minElement;

  auto y = 0;
  foreach (i; 0..n) y += fct[i] != lct[i];

  writeln(fct[n-1], " ", y, "/", n);
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
