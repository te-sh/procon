import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(size_t[]), w = rd[0], h = rd[1], n = rd[2];
  auto wh = w * h;

  if (wh == 1) {
    writeln(0);
    return;
  }

  auto hp = new int[][](h, w);
  auto vp = new int[][](w, h);

  foreach (_; 0..n) {
    auto m = readln.chomp.to!size_t;
    auto b = readln.chomp.splitter(' ');
    auto pr = b.front.to!size_t; b.popFront();
    foreach (i; 0..m) {
      auto s = pr, t = b.front.to!size_t; b.popFront(), pr = t;
      if (s > t) swap(s, t);
      auto sx = s % w, sy = s / w, tx = t % w, ty = t / w;
      if (sy == ty) {
        ++hp[sy][sx];
        --hp[sy][tx];
      } else {
        ++vp[sx][sy];
        --vp[sx][ty];
      }
    }
  }

  foreach (i; 0..h)
    foreach (j; 1..w)
      hp[i][j] += hp[i][j-1];

  foreach (i; 0..w)
    foreach (j; 1..h)
      vp[i][j] += vp[i][j-1];

  struct Qitem { size_t v; int len; }
  auto q = Queue!Qitem(wh), visited = new bool[](wh);
  q.insertBack(Qitem(0, 0));
  visited[0] = true;

  while (!q.empty) {
    auto qi = q.front; q.removeFront();
    auto u = qi.v, ux = u % w, uy = u / w;

    size_t[] vc;
    if (ux > 0 && hp[uy][ux-1]) vc ~= u - 1;
    if (ux < w-1 && hp[uy][ux]) vc ~= u + 1;
    if (uy > 0 && vp[ux][uy-1]) vc ~= u - w;
    if (uy < h-1 && vp[ux][uy]) vc ~= u + w;

    foreach (v; vc) {
      if (v == wh-1) {
        writeln(qi.len + 1);
        return;
      }
      if (!visited[v]) {
        visited[v] = true;
        q.insertBack(Qitem(v, qi.len + 1));
      }
    }
  }

  writeln("Odekakedekinai..");
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
