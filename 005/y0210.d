import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto pi = readln.split.to!(real[]).map!"a / 1000".array;
  auto qi = readln.split.to!(real[]).map!"a / 100".array;

  struct FP { real pq, qm; }
  auto hi = zip(pi, qi).map!(pq => FP(pq[0] * pq[1], 1 - pq[1])).array.heapify!"a.pq < b.pq";

  auto r = real(0);
  foreach (i; 1..1000000) {
    auto fp = hi.front;
    r += fp.pq * i;
    hi.replaceFront(FP(fp.pq * fp.qm, fp.qm));
  }

  writefln("%.4f", r);
}
