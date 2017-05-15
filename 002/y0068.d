import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

// allowable-error: 10 ** -9

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto li = readln.split.to!(real[]);
  auto q = readln.chomp.to!size_t;
  auto ki = readln.split.to!(size_t[]);

  struct LSP { real l, s; int p; }

  auto bi = li.map!(l => LSP(l, l, 1)).array.heapify!"a.s < b.s";
  auto ri = new real[](ki.fold!max + 1);
  foreach (i; 1..ri.length) {
    auto b = bi.front;
    ri[i] = b.s;
    bi.replaceFront(LSP(b.l, b.l / (b.p + 1), b.p + 1));
  }

  foreach (k; ki)
    writefln("%.10f", ri[k]);
}
