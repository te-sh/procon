import std.algorithm, std.conv, std.range, std.stdio, std.string;

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n, m; readV(n, m);
  auto a = readArray!int(n);
  auto g = new int[][](n);
  foreach (_; 0..m) {
    int u, v; readV(u, v); --u; --v;
    g[u] ~= v;
    g[v] ~= u;
  }

  foreach (i; 0..n) {
    auto b = a[i];
    auto c = a.indexed(g[i]);
    if (c.filter!(ci => ci < b).uniq.walkLength > 1 || c.filter!(ci => ci > b).uniq.walkLength > 1) {
      writeln("YES");
      return;
    }
  }

  writeln("NO");
}
