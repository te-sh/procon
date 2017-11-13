import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1];
  struct P { int i, x; }
  auto p = new P[](n);
  auto rd2 = readln.splitter;
  foreach (i; 0..n) {
    p[i] = P(i+1, rd2.front.to!int);
    rd2.popFront();
  }

  auto h = p[0..k].heapify!"a.x < b.x";
  writeln(h.front.i);

  foreach (i; k..n) {
    if (p[i].x < h.front.x)
      h.replaceFront(p[i]);
    writeln(h.front.i);
  }
}
