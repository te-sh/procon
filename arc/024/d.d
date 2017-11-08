import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto m = readln.chomp.to!size_t;

  struct P { int x, y; }
  auto p = new P[](m);

  foreach (i; 0..m) {
    auto rd = readln.split.to!(int[]), x = rd[0], y = rd[1];
    p[i] = P(x, y);
  }

  auto rb = redBlackTree(p.map!"a.x".array);

  auto v = new bool[][](1001, 1001);
  foreach (pi; p) {
    v[pi.y][pi.x] = true;
  }

  auto find(int xi) {
    int[] r;
    auto node = rb.tupleof[0].left;
    while (node.value != xi) {
      r ~= node.value;
      node = xi < node.value ? node.left : node.right;
    }
    return r;
  }

  P[] ans;
  foreach (pi; p) {
    auto r = find(pi.x);
    foreach (ri; r) {
      if (!v[pi.y][ri]) {
        ans ~= P(ri, pi.y);
        v[pi.y][ri] = true;
      }
    }
  }

  writeln(ans.length);
  foreach (ansi; ans)
    writeln(ansi.x, " ", ansi.y);
}
