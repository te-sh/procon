import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.math;      // math functions

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;

  struct Row
  {
    string large, small;
    int m;
  }

  auto rows = new Row[](n);
  foreach (i; 0..n) {
    auto rd = readln.split, large = rd[0], m = rd[1].to!int, small = rd[2];
    rows[i] = Row(large, small, m);
  }

  auto names = chain(rows.map!"a.large", rows.map!"a.small").array.sort().uniq.array;
  auto nn = names.length;
  size_t[string] n2i;
  foreach (i, name; names) n2i[name] = i;

  auto g = new size_t[][](nn), mt = new real[][](nn, nn);
  foreach (row; rows) {
    auto u = n2i[row.large], v = n2i[row.small];
    g[u] ~= v;
    g[v] ~= u;
    mt[u][v] = real(1)/row.m;
    mt[v][u] = row.m;
  }

  auto b = new real[](nn);
  auto q = DList!size_t(0);
  b[0] = 1;
  while (!q.empty) {
    auto u = q.front; q.removeFront();
    foreach (v; g[u]) {
      if (b[v].isNaN) {
        b[v] = b[u] * mt[u][v];
        q.insertBack(v);
      }
    }
  }

  string large, small;
  real ma = 0, mi = real.max;
  foreach (i; 0..nn) {
    if (b[i] > ma) {
      large = names[i];
      ma = b[i];
    }
    if (b[i] < mi) {
      small = names[i];
      mi = b[i];
    }
  }

  writeln(1, large, "=", (ma/mi).to!int, small);
}
