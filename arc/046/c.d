import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

void read2(S,T)(ref S a,ref T b){auto r=readln.splitter;a=r.front.to!S;r.popFront;b=r.front.to!T;}

version(unittest) {} else
void main()
{
  int n, m; read2(n, m);

  struct P { int a, b; bool male; }
  auto p = new P[](n+m);

  int a, b;
  foreach (i; 0..n) {
    read2(a, b);
    p[i] = P(a, b, true);
  }
  foreach (i; 0..m) {
    read2(a, b);
    p[i+n] = P(b, a, false);
  }

  p.sort!("a.a == b.a ? a.male < b.male : a.a < b.a");

  auto t = redBlackTree!(true, int)(), ans = 0;
  foreach (ref pi; p) {
    if (pi.male) {
      auto c = t.upperBound(pi.b-1);
      if (!c.empty) {
        t.removeKey(c.front);
        ++ans;
      }
    } else {
      t.insert(pi.b);
    }
  }

  writeln(ans);
}
