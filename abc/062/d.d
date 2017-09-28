import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

// path: arc074_b

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto s1 = new long[](n+1), s2 = new long[](n+1);

  auto q1 = a[0..n].heapify!"a>b";
  s1[0] = reduce!"a+b"(0L, a[0..n]);

  foreach (i; 0..n) {
    auto ai = a[n+i];
    s1[i+1] = s1[i];
    if (ai > q1.front) {
      s1[i+1] += ai - q1.front;
      q1.replaceFront(ai);
    } 
  }

  auto q2 = a[n*2..$].heapify!"a<b";
  s2[0] = reduce!"a+b"(0L, a[n*2..$]);

  foreach (i; 0..n) {
    auto ai = a[n*2-i-1];
    s2[i+1] = s2[i];
    if (ai < q2.front) {
      s2[i+1] -= q2.front - ai;
      q2.replaceFront(ai);
    }
  }

  auto ans = long.min;
  foreach (i; 0..n+1)
    ans = max(ans, s1[i] - s2[n-i]);

  writeln(ans);
}
