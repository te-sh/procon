import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], m = rd[1];
  auto x = readln.split.to!(int[]);

  auto gf = new int[][](n), gr = new int[][](n);
  foreach (i; 0..m) {
    auto rd2 = readln.split.to!(int[]), a = rd2[0]-1, b = rd2[1]-1;
    gf[a] ~= b;
    gr[b] ~= a;
  }

  auto num = new int[](n*2);

  auto winA(int y)
  {
    auto w = new int[](n*2);
    w[] = -1;

    auto q = DList!int();

    foreach (i; 0..n) {
      if (x[i] >= y) {
        w[i] = 1;
        q.insertBack(i);
      } else {
        w[n+i] = 1;
        q.insertBack(n+i);
      }

      if (gf[i].empty) {
        if (x[i] < y) {
          w[i] = 0;
          q.insertBack(i);
        } else {
          w[n+i] = 0;
          q.insertBack(n+i);
        }
      }
    }

    while (!q.empty) {
      auto u = q.front; q.removeFront();
      auto ui = u < n ? u : u-n;
      foreach (vi; gr[ui]) {
        auto v = u < n ? vi+n : vi;
        if (w[v] != -1) continue;
        if (w[u] == 0) {
          w[v] = 1;
          q.insertBack(v);
        } else if (w[u] == 1) {
          ++num[v];
          if (num[v] == gf[vi].length) {
            w[v] = 0;
            q.insertBack(v);
          }
        }
      }
    }

    return w[0] == 1;
  }

  auto bsearch = iota(x.reduce!min, x.reduce!max+1).map!(y => tuple(y, winA(y))).assumeSorted!"a[1] > b[1]";
  writeln(bsearch.lowerBound(tuple(0, false)).back[0]);
}
