import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, k = rd1[0].to!int, n = rd1[1].to!size_t;
  auto v = new int[][](n), w = new string[](n);
  foreach (i; 0..n) {
    auto rd2 = readln.split;
    v[i] = rd2[0].map!(c => c - '1').map!(to!int).array;
    w[i] = rd2[1];
  }

  auto q = DList!(string[])(["".repeat.take(k).array]);
 loop: while (!q.empty) {
    auto x = q.front; q.removeFront();
    foreach (i; 0..n) {
      auto wi = w[i];
      foreach (j, vj; v[i]) {
        auto xj = x[vj], xl = xj.length.to!int, wl = wi.length.to!int;
        if (!xj.empty) {
          if (wl < xl || wi[0..xl] != xj) continue loop;
          wi = wi[xl..$];
        } else {
          foreach (m; 1..4) {
            auto rw = wl - m, rv = v[i].length.to!int - j.to!int - 1;
            if (rw < rv || rw > rv * 3) continue;
            auto y = x.dup;
            y[vj] = wi[0..m];
            q.insertBack(y);
          }
          continue loop;
        }
      }
    }
    x.each!writeln;
    return;
  }
}
