import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);
  auto bi = readln.split.to!(int[]);

  auto hi = ai.map!(a => Monster(a, 0)).array.heapify!"a.lv != b.lv ? a.lv > b.lv : a.cnt > b.cnt";

  auto r = n;
  foreach (i; n.iota) {
    auto ci = hi.dup;
    auto di = bi.cycle.drop(i).take(n);
    auto maxCnt = 0;
    foreach (d; di) {
      auto c = ci.front;
      ci.replaceFront(Monster(c.lv + d / 2, c.cnt + 1));
      maxCnt = max(maxCnt, c.cnt + 1);
    }
    r = min(r, maxCnt);
  }

  writeln(r);
}

struct Monster {
  int lv;
  int cnt;
}
