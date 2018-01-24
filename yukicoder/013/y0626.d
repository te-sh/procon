import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

void readV(T...)(ref T t){auto r=readln.splitter;foreach(ref v;t){v=r.front.to!(typeof(v));r.popFront;}}
T[] readArray(T)(size_t n){auto a=new T[](n),r=readln.splitter;foreach(ref v;a){v=r.front.to!T;r.popFront;}return a;}
T[] readArrayM(T)(size_t n){auto a=new T[](n);foreach(ref v;a)v=readln.chomp.to!T;return a;}

version(unittest) {} else
void main()
{
  int n; long w; readV(n, w);
  VW[] vw;
  foreach (i; 0..n) {
    long vi, wi; readV(vi, wi);
    if (wi <= w) vw ~= VW(vi, wi);
  }
  n = vw.length.to!int;

  vw.sort!((a, b) => a.v.to!real/a.w > b.v.to!real/b.w);
  auto p = 0L;

  auto lowerUpper(int k, VW q)
  {
    auto l = q, u = 0.0L;
    foreach (i; k..n) {
      if (l.w + vw[i].w > w) {
        u = l.v + (w-l.w).to!real/vw[i].w * vw[i].v;
        break;
      }
      l = l + vw[i];
    }
    return tuple(l.v, max(u, l.v));
  }

  auto dfs(int k, VW q)
  {
    if (q.w > w) return;
    if (k == n-1) return;
    auto lu = lowerUpper(k, q);
    if (lu[1] < p) return;
    if (lu[0] > p) p = lu[0];
    dfs(k+1, q);
    dfs(k+1, q+vw[k]);
  }

  dfs(0, VW(0, 0));
  writeln(p);
}

struct VW
{
  long v, w;
  auto opBinary(string op: "+")(VW r) { return VW(v+r.v, w+r.w); }
}
