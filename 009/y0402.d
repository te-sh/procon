import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0]+4, w = rd[1]+4;

  auto s = new string[](h);
  s[0] = s[1] = s[$-1] = s[$-2] = '.'.repeat(w).array;
  foreach (r; 2..h-2) s[r] = ".." ~ readln.chomp ~ "..";

  auto g = new int[][](h, w);

  auto q = Queue!int(h*w);

  foreach (r; 0..h)
    foreach (c; 0..w)
      if (s[r][c] == '.') {
        g[r][c] = 1;
        if (r > 0 && r < h-1 && c > 0 && c < w-1)
          q.insertBack(c << 12 | r);
      }

  while (!q.empty) {
    auto p = q.front; q.removeFront();
    auto c = p >> 12, r = p & ((1 << 12) - 1);
    foreach (ir; -1..2)
      foreach (ic; -1..2) {
        auto nc = c + ic, nr = r + ir;
        if (!g[nr][nc]) {
          g[nr][nc] = g[r][c] + 1;
          q.insertBack(nc << 12 | nr);
        }
      }
  }

  auto d = 0;
  foreach (r; 2..h-2)
    foreach (c; 2..w-2)
      d = max(d, g[r][c]);

  writeln(d-1);
}

struct Queue(T)
{
  T[] buf;
  size_t s, t;

  this(size_t n) { buf = new T[](n); }
  auto empty() { return s == t; }
  auto front() { return buf[s]; }
  auto removeFront() { ++s; }
  auto insertBack(T v) { buf[t++] = v; }
}
