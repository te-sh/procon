import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], m = rd1[1], s = rd1[2], g = rd1[3];
  auto aij = new int[][](n, n);
  foreach (_; 0..m) {
    auto rd2 = readln.split, a = rd2[0].to!size_t, b = rd2[1].to!size_t, c = rd2[2].to!int;
    aij[a][b] = aij[b][a] = c;
  }

  auto di = dijkstra(aij, g);

  size_t[] calc(size_t[] route, int rest) {
    foreach (np; 0..n) {
      if (aij[route.back][np] == 0) continue;
      auto nrest = rest - aij[route.back][np];
      if (np == g && nrest == 0) return route ~ np;
      if (di[np] != nrest) continue;
      auto nroute = calc(route ~ np, nrest);
      if (!nroute.empty) return nroute;
    }
    return [];
  }

  writeln(calc([s], di[s]).to!(string[]).join(" "));
}

struct Edge(T) {
  size_t v;
  T w;
}

T[] dijkstra(T)(T[][] aij, size_t s, T inf = 0) {
  auto n = aij.length;
  auto di = new T[](n);
  di[] = inf;

  auto qi = heapify!("a.w > b.w")(Array!(Edge!T)());

  void addNext(Edge!T e) {
    auto v = e.v, w = e.w;
    di[v] = w;
    foreach (i; 0..n)
      if (aij[v][i] != inf && di[i] == inf)
        qi.insert(Edge!T(i, w + aij[v][i]));
  }

  addNext(Edge!T(s, 0));
  while (!qi.empty) {
    auto e = qi.front; qi.removeFront;
    if (di[e.v] == inf) addNext(e);
  }

  return di;
}
