import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ei = new size_t[][](n);
  foreach (_; 0..n-1) {
    auto rd = readln.split.to!(size_t[]).map!"a - 1", i = rd[0], j = rd[1];
    ei[i] ~= j;
    ei[j] ~= i;
  }

  auto fi = new int[](n);
  auto gi = new bool[](n);

  struct E { size_t u, p; int l; }

  auto si = new SList!E(E(0, n, 0));
  while (!si.empty) {
    auto s = si.front; si.removeFront();

    auto leaf = true;
    foreach (e; ei[s.u]) {
      if (e == s.p) continue;
      leaf = false;
      fi[e] = s.l + 1;
      si.insertFront(E(e, s.u, s.l + 1));
    }

    gi[s.u] = leaf;
  }

  foreach (i; 0..n) {
    if (!gi[i]) continue;

    fi[i] = 0;
    auto ti = new SList!E(E(i, n, 0));
    while (!ti.empty) {
      auto t = ti.front; ti.removeFront();

      foreach (e; ei[t.u]) {
        if (e == t.p || fi[e] <= t.l + 1) continue;
        fi[e] = t.l + 1;
        ti.insertFront(E(e, t.u, t.l + 1));
      }
    }
  }

  fi.each!writeln;
}
